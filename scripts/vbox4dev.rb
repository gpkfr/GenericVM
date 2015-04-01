# -*- mode: ruby -*-
# # vi: set ft=ruby :
#

class Vbox
  def Vbox.configure(config,settings)
    config.ssh.shell = "bash -s"
    #Configure the Box
    config.vm.box = settings["vagrant_box"] ||= "gpkfr/wheezy64_fr_v7"

#    server_ip = settings["ip"] ||= "192.168.10.10"

    #Configure A private Network
    if "private" == settings["network_type"]
      config.vm.network "private_network", ip: settings["ip"] ||= "192.168.212.230", auto_config: true
    end

    if "public" == settings["network_type"]
      config.vm.network "public_network"
    end
    #config.vm.network "private_network", type: "dhcp"

    config.vm.hostname = "DevMachine"

    # Configure A Few VmWare-Fusion Settings
    config.vm.provider "vmware_fusion" do |v, override|
      v.vmx["displayName"] = "DevMachine"
      v.vmx["memsize"] = settings["memory"] ||= "1024"
      v.vmx["numvcpus"] = settings["cpus"] ||= "1"
      #v.vmx["ethernet0.connectiontype"] = settings["connectiontype"] ||= "nat"
      #v.vmx["ethernet0.connectiontype"] = settings["connectiontype"] ||= "bridged"
      #v.vmx["ethernet0.linkStatePropagation.enable"] = "TRUE"
    end

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "1024"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end


    # Configure Port Forwarding
    if settings.has_key? ("forwarded_port")
      settings["forwarded_port"].each do |port|
        config.vm.network :forwarded_port, guest: port["guest"], host: port["host"], protocol: port["protocol"] ||= "tcp"
       end
    end

    # Configure The Public Key For SSH Access
    if settings["authorized_keys"]
      settings["authorized_keys"].each do |authkey|
        config.vm.provision "shell" do |s|
          s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
          s.args = [File.read(File.expand_path(authkey))]
        end
      end
    end

    # Copy The SSH Private Keys To The Box
    if settings["private_keys"]
      settings["private_keys"].each do |key|
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
          s.args = [File.read(File.expand_path(key)), key.split('/').last]
        end
      end
    end

    # Register All Of The Configured Shared Folders
    if settings["shared_folders"]
      settings["shared_folders"].each do |folder|
        if folder["type"]
          config.vm.synced_folder folder["map"], folder["to"],id: folder["map"],
            type: folder["type"], nfs_export: true
        else
          config.vm.synced_folder folder["map"], folder["to"],id: folder["map"]
        end
      end
    end

    #########################
    # Provision with puppet #
    #########################
    #
    config.vm.provision :puppet, :module_path => "modules" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = settings["manifest"] ||= "default.pp"

      #Facter
      if settings["facters"] and settings["facters"].isa? Hash
        puppet.facter = settings["facters"]
      end

      #puppet.facter = {
      #  "host_ip" => settings["host_ip"] || %x{netstat -rn | grep "127.0.0.1" |grep -v "^127"|cut  -f 1 -d" "}
      #}
      #puppet.options = "--verbose --debug"
    end

  end
end
