file { "/home/vagrant/www":
      ensure => directory,
      owner  => 'vagrant',
      group  => 'vagrant',
}

class {'laravel':
  use_xdebug      => false, # install and configure xdebug ; If used with vmware_fusion uncomment remote_host_ip and put your host ip.
  use_hhvm        => false, # install hhvm
  #remote_host_ip => "10.0.0.69", # Needed for xdebug when using Vmware; delete or comment if you use virtualbox.
  database_server => "none", # Possible value : none, mysql, postgresql,sqlite
  install_node    => true,
  npm_pkg         => ["gulp","bower","grunt"],
}


# Configure your(s) vhost(s)
laravel::vhost { 'test.local':
  root_dir => "/home/vagrant/www/public",
  require  => File["/home/vagrant/www"],
}
