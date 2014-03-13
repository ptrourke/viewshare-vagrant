# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "raring64"
  config.vm.hostname = "deploy"
#  config.ssh.username = "wamberg"
#  config.ssh.private_key_path = "/home/wamberg/.ssh/id_rsa"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-i386-vagrant-disk1.box"

  config.vm.synced_folder "salt/", "/srv/salt/"

  config.vm.network :forwarded_port, guest: 80, host: 8000
  config.vm.network :private_network, ip: "192.168.2.2"

  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
end
