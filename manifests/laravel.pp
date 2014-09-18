Exec["apt update"] -> Package <| |>

exec { "apt update":
    command => "/usr/bin/apt-get update",
}

file { "/home/vagrant/www":
      ensure => directory,
      #      owner  => 'vagrant',
      #      group  => 'vagrant',
}

class {'laravel':
  use_xdebug         => false, # install and configure xdebug ; If used with vmware_fusion uncomment remote_host_ip and put your host ip.
  use_hhvm           => false, # install hhvm (experimental)
  #remote_host_ip    => "10.0.0.69", # Needed for xdebug when using Vmware; delete or comment if you use virtualbox.
  remote_host_ip    => $::host_ip, # Needed for xdebug when using Vmware; delete or comment if you use virtualbox.
  database_server    => "mysql", # Possible value : none, mysql, postgresql,sqlite.
  # When installed mysql and postgresql create an empty database "laravel" with user/pass == root/root
  install_redis      => true,
  install_beanstalkd => false,
  install_node       => false,
  npm_pkg            => ["gulp","bower","grunt","grunt-cli"],
}


# Configure your(s) vhost(s)
laravel::vhost { 'test.local':
  root_dir => "/home/vagrant/www/public",
  require  => File["/home/vagrant/www"],
}

