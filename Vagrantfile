# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "trusty64" # give the box file an alias of trusty64
  config.vm.hostname = "deploy" # the hostname of the new VM will be "deploy"
  #config.ssh.username = "ptrourke" #for use after deployment, leave commented out
  #config.ssh.private_key_path = "/home/ptrourke/.ssh/id_rsa" #for use after deployment, leave commented out
  config.vm.box_url = "http://cloud-images.ubuntu.com/trusty/raring/current/trusty-server-cloudimg-i64-vagrant-disk1.box" # if it is not cached, download this box file

  config.vm.synced_folder "salt/", "/srv/salt/" # map the subfolder "salt" of the project with the folder "/srv/salt" on the VM

  config.vm.network :forwarded_port, guest: 80, host: 8000 # forward port 80 on the VM to port 8000 on the host 
  config.vm.network :private_network, ip: "192.168.2.2" # use a private network

  # use the SALT provisioner
  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.verbose = true
    salt.run_highstate = true
  end

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
end
