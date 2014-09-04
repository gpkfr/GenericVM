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
