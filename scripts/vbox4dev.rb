# -*- mode: ruby -*-
# # vi: set ft=ruby :
#
$auth_script = <<AUTH_SCRIPT
echo $1|grep -xq -- \"$1\" /home/vagrant/.ssh/authorized_keys || ((echo $1 | tee -a /home/vagrant/.ssh/authorized_keys) && echo "Populated Authorized_keys with $2")
AUTH_SCRIPT

$private_key = <<PK_SCRIPT
test -f /home/vagrant/.ssh/$2 && echo $1|grep -xq -- \"$1\" /home/vagrant/.ssh/$2 || ((echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2) && echo "added Private key $2")
PK_SCRIPT

class Vbox
  def Vbox.configure(config,settings)
    config.ssh.shell = "bash -s"
    #Configure the Box
    config.vm.box = settings["vagrant_box"] ||= "gpkfr/wheezy64_fr_v7"

#    server_ip = settings["ip"] ||= "192.168.10.10"

    #Configure A private Network
    if "private" == settings["network_type"]
      config.vm.network :private_network, ip: settings["ip"] ||= "192.168.212.230", auto_config: true
    end

    if "public" == settings["network_type"]
      config.vm.network :public_network
    end

    config.vm.hostname = "DevMachine"

    # Configure A Few VmWare Settings
    ["vmware_fusion", "vmware_workstation"].each do |vmware|
      config.vm.provider vmware do |v, override|
        v.vmx["displayName"] = "DevMachine"
        v.vmx["memsize"] = settings["memory"] ||= "1024"
        v.vmx["numvcpus"] = settings["cpus"] ||= "1"
        v.vmx["guestos"] = settings["ostype"] || "debian7-64"
        #v.vmx["ethernet0.connectiontype"] = settings["connectiontype"] ||= "nat"
        #v.vmx["ethernet0.connectiontype"] = settings["connectiontype"] ||= "bridged"
        #v.vmx["ethernet0.linkStatePropagation.enable"] = "TRUE"
      end
    end

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.name = 'DevMachine'
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "1024"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ostype", settings["ostype"] || "Debian_64"]
    end


    # Configure Port Forwarding
    if settings.has_key? ("forwarded_port")
      settings["forwarded_port"].each do |port|
        config.vm.network :forwarded_port, guest: port["guest"], host: port["host"], protocol: port["protocol"] ||= "tcp"
       end
    end
    
    # Configure The Public Key For SSH Access
    if settings.include? 'authorized_keys'
      settings["authorized_keys"].each do |authkey|
        config.vm.provision "shell" do |s|
          s.inline = $auth_script
          s.args = [File.read(File.expand_path(authkey)), authkey]
        end
      end
    end


    # Copy The SSH Private Keys To The Box
    if settings.include? 'private_keys'
      settings["private_keys"].each do |key|
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = $private_key
          s.args = [File.read(File.expand_path(key)), key.split('/').last]
        end
      end
    end

    # Register All Of The Configured Shared Folders
    if settings.include? 'shared_folders'
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
      factercfg = {
        "hostip" => settings["host_ip"] || %x{ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ printf "%s", $2 }'},
        "vagrant" => 4,
      }

      if settings["facters"] and settings["facters"].is_a? Hash
        factercfg.merge!(settings["facters"])
      end

      puppet.facter = factercfg

      if settings.has_key? ("debug") and settings["debug"]
        puts puppet.facter
        puppet.options = "--verbose --debug"
      end
   end

  end
end
