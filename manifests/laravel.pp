file { "/home/vagrant/www":
      ensure => directory,
      owner  => 'vagrant',
      group  => 'vagrant',
}

class {'laravel':
  use_xdebug      => true,
  remote_host_ip  => "10.0.0.69",
  database_server => "mysql",
}

laravel::vhost { 'test.local':
  root_dir => "/home/vagrant/www/public",
  require  => File["/home/vagrant/www"],
}
