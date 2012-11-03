# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :development do |dev|
    dev.vm.box = "precise64"
    dev.vm.box_url = "http://files.vagrantup.com/precise64.box"

    dev.vm.host_name = "development"

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
end
