Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'] }
Exec['apt-get update'] -> Package <| |>

node default {
  # Ensures custom functions from modules are available
  $file = join(['tmp', 'stdlib-test'], '/')
  file { "/${file}": content => 'it works!' }

  # Ensures hiera lookup works
  $var = hiera('var')
  file { '/tmp/hiera': content => $var }

  # Ensures "global" templates can be found
  $template_var = 'Template working!'
  file { '/tmp/template': content => template('test-template.erb') }

  # Ensures git modules can be installed
  exec { 'apt-get update': user => root }
  rbenv::install { 'vagrant':; }
}
