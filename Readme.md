# Vagrant Box with Debian 7
This box provide a Linux basic installation fully custumizable with puppet

## installation

* Clone this repo [ git clone git@github.com:gpkfr/GenericVM.git GVM && cd GVM ]
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

* nginx
* php5-fpm
* Mysql-Server (optionnal)
* redis-server
