namespace :setup do
  def ask(question, default = nil)
    begin
      print "#{question} "
      print "[#{default}] " unless default.to_s.empty?
      answer = $stdin.gets.chomp
      answer = answer.empty? ? default : answer
    end while answer.nil?
    answer
  end

  def read_ssh_key_file(question)
    default = Dir["#{ENV['HOME']}/.ssh/id_{d,r}sa.pub"].first
    file = ask(question, default)

    if file.empty?
      puts "You need to provide an SSH key file to be used"
      exit 1
    end

    file
  end

  desc 'Configures project for use with remote server'
  task :server do
    server     = ask("What's the server IP or URL?")
    setup_user = ask('Which user will be used for setting up the server?', 'root')
    ssh_port   = ask('Which SSH port should be used for setting up the server?', 22)
    puppet_key = read_ssh_key_file('Which SSH key you want to use to manage the remote server repository?')

    remote_setup_script = '/tmp/server-setup'
    sh "scp -P #{ssh_port} #{puppet_key} #{setup_user}@#{server}:/tmp/puppet-git-key"
    sh "scp -P #{ssh_port} #{Dir.pwd}/scripts/server-setup #{setup_user}@#{server}:#{remote_setup_script}"
    sh "scp -P #{ssh_port} #{Dir.pwd}/scripts/git-post-update-hook #{setup_user}@#{server}:/tmp/git-post-update-hook"
    sh "ssh -p #{ssh_port} #{setup_user}@#{server} 'chmod +x #{remote_setup_script} && #{remote_setup_script}'"

    puts "\n\nYou can now add the server as a git remote and start pushing your manifests:"
    puts "  git remote add server ssh://puppet-git@#{server}:#{ssh_port}/var/lib/puppet-git-receiver/puppet.git"
  end
end
