# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "genebean/centos6-rvm193-64bit"

  config.vm.synced_folder "./", "/home/vagrant/puppet-moddeps"

  config.vm.provision "shell", inline: "yum -y install dos2unix git nano ruby-devel tree vim-enhanced"
  config.vm.provision "shell", inline: "dos2unix /vagrant/scripts/*.sh"
  config.vm.provision "shell", inline: "su - vagrant -c 'export PUPPET_VERSION=3.7.3; /vagrant/scripts/vagrant-user.sh'"

end
