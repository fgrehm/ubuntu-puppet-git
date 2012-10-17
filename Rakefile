require 'rubygems'
require 'rake'

FileList['tasks/**/*.rake'].each { |task| import task }

desc 'Default: run puppet-lint on your manifests'
task :default => :lint
