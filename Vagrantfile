# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

path = "#{File.dirname(__FILE__)}"

require 'yaml'
require path + '/scripts/vbox4dev.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Vbox.configure(config, YAML::load(File.read(path + '/vbox4dev.yaml')))
end
