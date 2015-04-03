# Vagrant Box with Debian 7
This Vagrant Box provides a system Gnu / Debian allowing very rapid establishment of an environment for developer and system administrator. Unlike other systems such as Homestead, GenericVM is fully configurable via puppet and offers as an example a manifest for Laravel puppet that you can use without effort. you are not limited in the use of GenericVM and you are totally free to set your BOX as desired.


## Install via Composer (

* install composer
* execute as normal user : composer global require 'gpkfr/myvm=~0.0'
* link ~/.composer/vendor/bin/myvm on /usr/local/bin or configure your $PATH

### Myvm Usage

* $ myvm init project_name
* edit project_name/config.yaml
* cd project_name
* exec vagrant up

## Manual installation

* Clone this repo [   ]
* Execute [ git submodule init && git submodule update ] [required]
* install additional puppet module as git submodule in modules directory [Optionnal]
* create puppet manifest in manifest Directory [Optionnal]
* Edit to your needs config.yaml [Required] (see sample file)
* create vm [ vagrant up --provider [vmware_fusion || virtualbox] ]

Happy Dev ;)

Feel Free to contribute

## Puppet Manifest

### Default
Default manifest is only a POC and/or a starting point to create
wonderfull install ;)

### Laravel
Laravel manifest provides you development environment without pain. It
use a puppet module (laravel) to install the Nginx web server, php5-fpm, Mysql-server, Redis-server
and more (in fact all what you need).

Software installed :

* Gnu/Debian (stable Version)
* nginx
* php5-fpm or hhvm
* Mysql-Server, postgresql, sqlite3 or none (optionnal)
* redis-server
* Nodejs(stable version or specific version)
* Bower, Grunt, Gulp

### Webreader
Webreader manifest provides you development environment for a private nodejs project and is a good start for all nodejs development.

***

#Starting a new project

## What do you need ?

* (vagrant)[https://www.vagrantup.com]
* (virtualbox >= 4.3.14)[https://www.virtualbox.org] [option]
* (vmware fusion >= 7.0)[http://store.vmware.com/store?SiteID=vmwde&Action=DisplayProductDetailsPage&productID=304745700]

## Where to start ?

### Introduction

the vagrant box is empty by default and must be configured with puppet manifest. GenericVm Provide the "eco-system" and is very flexible. All your project source file (php, javascript, html) are stored on the host(the computer you are using now) and shared with the virtual  environment (the guest).

In fact, you can destroy VM without lost your code( except for db data ) ;

1. Prepare GenericVm
	1.1 **git clone git@github.com:gpkfr/GenericVM.git GVM && cd GVM**
	1.2 **git submodule init && git submodule update

2. Edit file config.yaml
	2.1 cp config.yaml.sample config.yaml
	2.2 the file is self documented and in (yaml)[http://symfony.com/legacy/doc/reference/1_4/fr/02-YAML] format

3. Create or edit a (puppet)[https://docs.puppetlabs.com] manifest
	3.1 GenericVM provide some manifest as Poc. ./manifests/Laravel.pp is a good starting point and very easy to configure and self documented. don't be afraid ;)

4. Start VM
	4.1 vagrant up
	4.2 connect to your site ; Ex : (localsite)[http://127.0.0.1:8080]

### some Vagrant Command

1. Start VM -> vagrant up
2. Stop VM  -> vagrant halt
3. Delete VM -> vagrant destroy
4. connect to vm -> vagrant ssh
5. get ssh config -> vagrant ssh-config
6. get help ;) -> vagrant help


