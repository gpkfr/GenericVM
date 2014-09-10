file { "/home/vagrant/www":
      ensure => directory,
      owner  => 'vagrant',
      group  => 'vagrant',
}

class {'laravel':
  use_xdebug      => false,
  remote_host_ip  => "10.0.0.69", # Needed for xdebug when using Vmware
  database_server => "none", # Possible value : none, mysql, postgresql,sqlite
  use_hhvm        => true, # install hhvm
}

laravel::vhost { 'test.local':
  root_dir => "/home/vagrant/www/public",
  require  => File["/home/vagrant/www"],
}
