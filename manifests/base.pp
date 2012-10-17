# Base definitions used for the server and the development machine

Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'] }
Exec['apt-get update'] -> Package <| |>

node base {
  exec { 'apt-get update': }
}
