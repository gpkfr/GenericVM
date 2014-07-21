Exec["apt-update"] -> Package <| |>

exec { "apt-update":
    command => "/usr/bin/apt-get update",
}

package {"screen":
  ensure => latest,
}

file { '/home/vagrant/.screenrc':
  source  => '/vagrant/files/screenrc',
  owner => 'vagrant',
  group => 'vagrant',
  mode  => '644',
  require => Package['screen'],
}