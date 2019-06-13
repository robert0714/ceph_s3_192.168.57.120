# -*- mode: ruby -*-
# vi: set ft=ruby :
nodes = [   
  { :hostname => 'mon1', :ip => '192.168.57.121', :box => 'xenial64' }, 
  { :hostname => 'mon2', :ip => '192.168.57.122', :box => 'xenial64' }, 
  { :hostname => 'mon3', :ip => '192.168.57.123', :box => 'xenial64' }, 
  { :hostname => 'osd1',  :ip => '192.168.57.131', :box => 'xenial64', :ram => 1024, :osd => 'yes' }, 
  { :hostname => 'osd2',  :ip => '192.168.57.132', :box => 'xenial64', :ram => 1024, :osd => 'yes' }, 
  { :hostname => 'osd3',  :ip => '192.168.57.133', :box => 'xenial64', :ram => 1024, :osd => 'yes' } 
] 
Vagrant.configure(2) do |config|
  if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
  else
    config.vm.synced_folder ".", "/vagrant"
  end
  config.vm.define "ansible" do |d| 
    d.vm.box =  "bento/ubuntu-16.04" 
    d.vm.hostname = "ansible"
    d.vm.network "public_network", bridge: "eno4", ip: "192.168.57.120", auto_config: "false", netmask: "255.255.255.0" , gateway: "192.168.57.1"
    # IP address of your LAN's router 
    default_router = "192.168.57.1"       
    # change/ensure the default route via the local network's WAN router, useful for public_network/bridged mode
    d.vm.provision :shell, inline: "ip route delete default 2>&1 >/dev/null || true; ip route add default via #{default_router}"
    d.vm.provision :shell, path: "scripts/bootstrap4CentOs_ansible.sh"   
    d.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end
  end  
  nodes.each do |node| 
    config.vm.define node[:hostname] do |nodeconfig| 
      nodeconfig.vm.box = "bento/ubuntu-16.04" 
      nodeconfig.vm.hostname = node[:hostname] 
      nodeconfig.vm.network :"public_network", bridge: "eno4", ip: node[:ip] , auto_config: "false", netmask: "255.255.255.0" , gateway: "192.168.57.1"
      default_router = "192.168.57.1"       
      # change/ensure the default route via the local network's WAN router, useful for public_network/bridged mode
      nodeconfig.vm.provision :shell, inline: "ip route delete default 2>&1 >/dev/null || true; ip route add default via #{default_router}"
    
      memory = node[:ram] ? node[:ram] : 512; 
      nodeconfig.vm.provider :virtualbox do |vb| 
        vb.customize [ 
          "modifyvm", :id, 
          "--memory", memory.to_s, 
        ] 
        if node[:osd] == "yes"         
          vb.customize [ "createhd", "--filename", "disk_osd-#{node[:hostname]}", "--size", "10000" ] 
          vb.customize [ "storageattach", :id, "--storagectl", "SATA Controller", "--port", 3, "--device", 0, "--type", "hdd", "--medium", "disk_osd-#{node[:hostname]}.vdi" ] 
        end 
      end 
    end 
    config.hostmanager.enabled = true 
    config.hostmanager.manage_guest = true 
  end   
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.vbguest.no_install = true 
    config.vbguest.no_remote = true
  end
  # Install of dependency packages using script
  # config.vm.provision :shell, path: "./hack/setup-vms.sh"
end
