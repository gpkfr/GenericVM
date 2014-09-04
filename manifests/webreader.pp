
class {
  'webreader':
    bypass_node    => false,
}



# wr

webreader::vhost { 'test.local':
  script_name => 'wr',
  node_port   => '3000',
  wruser      => 'vagrant',
  wrgrp       => 'vagrant',
  nodeapp_dir => '/home/vagrant/www/wr/',
  server_js   => 'dist/server.js',
  root_dir    => '/home/vagrant/www',
  vagrant     => true
  }
