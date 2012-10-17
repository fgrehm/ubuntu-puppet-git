require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.ignore_paths = [ "modules/**/*.pp" ]
