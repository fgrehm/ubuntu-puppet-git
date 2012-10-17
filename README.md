# Ubuntu Server Puppet

Easy set up and management for Ubuntu 12.04 Server boxes using Puppet 3.0 and
a Git repository.


## Overview

The idea of the project is to provide you with with some basic infrastructure
for managing your servers using Puppet and a Git repository and to ease testing
using [Vagrant](http://vagrantup.com/). It comes with support for using
[hiera](http://projects.puppetlabs.com/projects/hiera) to configure your boxes
and [librarian-puppet](http://librarian-puppet.com) to manage the Puppet
modules your infrastructure depend on.


## Usage

Clone the project and run `rake setup:server` to configure your local machine
and bootstrap the server.

Please note that the
[server setup script](https://github.com/fgrehm/ubuntu-server-puppet/blob/master/scripts/server-setup)
was tested on a clean Linode Ubuntu 12.04 box, make sure you read it before trying
on a different distro or on an existing box.

If everything goes fine, your `origin` repository will be set to the remote
machine and you can add Puppet modules to your `Puppetfile` and edit the manifests
at the `manifests` folder. Every time you push your changes to the remote repo,
the Puppet manifests will be applied using the script at `scripts/apply-manifests`.


## Testing changes locally before pushing

    TODO


## Acknowledgement

Special thanks to everyone that contributed to the original Git hook and machine
setup scripts from [puppet-git-receiver](https://github.com/brightbox/puppet-git-receiver)


## License ##

MIT License.

Copyright (c) 2012 Fábio Rehm
