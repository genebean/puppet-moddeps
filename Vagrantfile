# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "genebean/centos6-puppet-64bit"

  config.vm.synced_folder "./", "/home/vagrant/puppet-moddeps"

  config.vm.provision "shell", inline:   "yum -y install vim-enhanced tree git"
  config.vm.provision "shell", inline:   "gem install bundler --no-ri --no-rdoc"

end
