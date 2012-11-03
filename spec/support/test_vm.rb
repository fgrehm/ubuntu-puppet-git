# TODO: Find out what this can do for us
# https://github.com/mitchellh/vagrant/blob/master/lib/vagrant/test_helpers.rb

module TestVM
  def vm_powered_on?
    test_vm.state == :running
  end

  def recreate_vm!
    return if ENV['SKIP_RECREATE_VM'] == '1'

    puts "Recreating test VM"

    test_vm.destroy if test_vm.created?
    test_vm.up
		key = Dir["#{ENV['HOME']}/.ssh/id_{r,d}sa.pub"].first
    vm_channel.upload key, '/tmp/puppet-git-key'
  end

  def setup_vm!
    return if ENV['SKIP_SETUP_VM'] == '1'

    puts "Running setup script"

    hook = "#{Dir.pwd}/scripts/git-post-update-hook"
    vm_channel.execute("rm -rf /tmp/git-post-update-hook")
    vm_channel.upload hook, '/tmp/git-post-update-hook'
    script = '/vagrant/scripts/server-setup'
    raise 'Unable to run setup script!' unless vm_channel.execute("#{script} > /tmp/initial-setup.log", :error_check => false) == 0
  end

  def vm_channel
    @channel ||= test_vm.channel
  end

  def test_vm
    @vm ||= vagrant_env.vms[:test]
  end

  def vagrant_env
    @vagrant_env ||= Vagrant::Environment.new
  end

  def run(cmd, opts = {})
    stdout = ''
    opts = { :error_check => false }.merge(opts)
    vm_channel.execute(cmd, opts) do |out, data|
      stdout << data if out == :stdout
    end
    stdout.strip
  end

  def ssh_port
    test_vm.ssh.info[:port]
  end
end
