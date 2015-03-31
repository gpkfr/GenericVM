Exec["apt update"] -> Package <| |>

exec { "apt update":
    command => "/usr/bin/apt-get update",
}

file { "/home/vagrant/www":
      ensure => directory,
      owner  => 'vagrant',
      group  => 'vagrant',
}

class {'laravel':
  # install and configure xdebug ; If used with vmware_fusion uncomment remote_host_ip and put your host ip.
  use_xdebug         => $::xdebug ? { 'true' => true, 'false' => false, default => false},
  # install hhvm (experimental)
  use_hhvm           => $::hhvm ? { 'true' => true, 'false' => false, default => false},
  #remote_host_ip    => "10.0.0.69", # Needed for xdebug when using Vmware; delete or comment if you use virtualbox.
  #remote_host_ip    => $::host_ip, # Needed for xdebug when using Vmware; delete or comment if you use virtualbox.
  # Possible value : none, mysql, postgresql,sqlite.
  # When installed mysql and postgresql create an empty database "laravel" with user/pass == root/root
  database_server    => $::dbserver ? { 'sqlite' => 'sqlite', 'mysql' => 'mysql', 'postgresql' => 'postgresql', default => 'none' },
  install_redis      => $::redis ? { 'true' => true, 'false' => false, default => false},
  install_beanstalkd => $::beanstalkd ? { 'true' => true, 'false' => false, default => false},
  install_node       => $::node ? { 'true' => true, 'false' => false, default => false},
  npm_pkg            => ["gulp","bower","grunt","grunt-cli"],
}


# Configure your(s) vhost(s)
laravel::vhost { 'test.local':
  root_dir => "/home/vagrant/www/public",
  require  => File["/home/vagrant/www"],
}

