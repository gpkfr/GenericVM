# -*- mode: ruby -*-
# # vi: set ft=ruby :
#

class Vbox
  def Vbox.configure(config,settings)
    config.ssh.shell = "bash -s"
    #Configure the Box
    config.vm.box = "gpkfr/wheezy64_fr_v7"

#    server_ip = settings["ip"] ||= "192.168.10.10"

    #Configure A private Network
    #config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

    # Configure A Few VmWare-Fusion Settings
    config.vm.provider "vmware_fusion" do |v, override|
      override.vm.box = "gpkfr/wheezy64_fr_v7"
      v.vmx["memsize"] = settings["memory"] ||= "2048"
      v.vmx["numvcpus"] = settings["cpus"] ||= "1"
    end

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end


    # Configure Port Forwarding
    if settings["forwarded_port"]
		  settings["forwarded_port"].each do |port|
			  config.vm.network :forwarded_port, guest: port["guest"], host: port["host"]
		  end
    end

    # Configure The Public Key For SSH Access
    settings["authorized_keys"].each do |authkey|
      config.vm.provision "shell" do |s|
        s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
        s.args = [File.read(File.expand_path(authkey))]
      end
    end

    # Copy The SSH Private Keys To The Box
    settings["private_keys"].each do |key|
      config.vm.provision "shell" do |s|
        s.privileged = false
        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
        s.args = [File.read(File.expand_path(key)), key.split('/').last]
      end
    end

    # Register All Of The Configured Shared Folders
    settings["shared_folders"].each do |folder|
      config.vm.synced_folder folder["map"], folder["to"]
    end

    #########################
    # Provision with puppet #
    #########################
    #
    config.vm.provision :puppet, :module_path => "modules" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = settings["manifest"] ||= "default.pp"
    end

  end
end
