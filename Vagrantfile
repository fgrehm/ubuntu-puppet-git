# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :development do |dev|
    # All Vagrant configuration is done here. The most common configuration
    # options are documented and commented below. For a complete reference,
    # please see the online documentation at vagrantup.com.

    # Every Vagrant virtual environment requires a box to build off of.
    dev.vm.box = "precise64"
    dev.vm.box_url = "http://files.vagrantup.com/precise64.box"

    dev.vm.host_name = "development"

    # Boot with a GUI so you can see the screen. (Default is headless)
    # dev.vm.boot_mode = :gui

    # Assign this VM to a host-only network IP, allowing you to access it
    # via the IP. Host-only networks can talk to the host machine as well as
    # any other machines on the same network, but cannot be accessed (through this
    # network interface) by any external networks.
    # dev.vm.network :hostonly, "192.168.33.10"

    # Assign this VM to a bridged network, allowing you to connect directly to a
    # network using the host's network device. This makes the VM appear as another
    # physical device on your network.
    # dev.vm.network :bridged

    # Forward a port from the guest to the host, which allows for outside
    # computers to access the VM, whereas host only networking does not.
    dev.vm.forward_port 80, 8081

    # Share an additional folder to the guest VM. The first argument is
    # an identifier, the second is the path on the guest to mount the
    # folder, and the third is the path on the host to the actual folder.
    # dev.vm.share_folder "v-data", "/vagrant_data", "../data"

    dev.hiera.config_path       = './configuration'
    dev.hiera.config_file       = 'hiera-vagrant.yaml'
    dev.hiera.data_path         = './configuration/data'
    dev.hiera.puppet_apt_source = 'deb http://apt.puppetlabs.com/ precise main'

    dev.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path    = "modules"
      puppet.manifest_file  = "development.pp"
      puppet.options = [ '--templatedir', '/vagrant/templates' ]
      puppet.options << [ '--debug --verbose' ] if ENV['DEBUG'] == '1'
    end
  end

  config.vm.define :test do |test|
    test.vm.box = "precise64"
    test.vm.box_url = "http://files.vagrantup.com/precise64.box"
    test.vm.host_name = "test"
  end
end
