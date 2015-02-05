Exec["apt update"] -> Package <| |>

exec { "apt update":
    command => "/usr/bin/apt-get update",
}

class {
  'webreader':
    bypass_node    => false,
}



# wr

webreader::vhost { 'test.local':
  script_name    => 'wr',
  node_port      => '3000',
  nginx_port     => '8080',
  wruser         => 'vagrant',
  wrgrp          => 'vagrant',
  nodeapp_dir    => '/home/vagrant/www/',
  server_js      => 'dist/server.js',
  root_dir       => '/home/vagrant/www',
  vagrant        => true,
  bucket_s3      => 'gt-media-default.s3-eu-west-1.amazonaws.com',
  awsaccessKeyId => 'AKIAIKWIOCTNVWEGP5LA',
  }


