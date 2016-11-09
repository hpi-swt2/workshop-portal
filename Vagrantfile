
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "swt2/trusty64"
  config.vm.box_url = "https://github.com/hpi-swt2/swt2-vagrant/releases/download/v0.2/swt2-trusty64.box"

  # use 32bit machine
  #config.vm.box = "swt2/trusty32"
  #config.vm.box_url = "https://github.com/hpi-swt2/swt2-vagrant/releases/download/v0.2/swt2-trusty32.box"

  # previously there were performance issues. Try to use the following optimizations
  # disable if problems occur or fall back to the 32bit VM
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", 2]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
  end

  # port forward
  config.vm.network :forwarded_port, host: 3000, guest: 3000
  config.vm.synced_folder ".", "/home/vagrant/hpi-swt2"
end