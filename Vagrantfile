# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

require 'yaml'

path = "#{File.dirname(__FILE__)}"

require_relative 'scripts/vbox4dev.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Vbox.configure(config, YAML::load(File.read(path + '/config.yaml')))
end
