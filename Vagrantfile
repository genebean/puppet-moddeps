# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "genebean/centos-7-rvm-multi"

  config.vm.network "forwarded_port", guest: 8808, host: 8808 # used for Yard docs

  config.vm.synced_folder "./", "/home/vagrant/puppet-moddeps"

  config.vm.provision "shell", inline: "yum -y install dos2unix git nano ruby-devel tree vim-enhanced"
  config.vm.provision "shell", inline: "echo 'install bundler after selecting a ruby with RVM'"
end
