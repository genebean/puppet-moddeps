# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "genebean/centos6-puppet-64bit"

  config.vm.define "dev", primary: true do |dev|

    dev.vm.synced_folder "./", "/home/vagrant/puppet-moddeps"

    dev.vm.provision "shell", inline: "yum -y install dos2unix git nano ruby-devel tree vim-enhanced"
    dev.vm.provision "shell", inline: "dos2unix /vagrant/scripts/vagrant-user.sh"
    dev.vm.provision "shell", inline: "su - vagrant -c '/vagrant/scripts/vagrant-user.sh'"
    dev.vm.provision "shell", path:   "scripts/pretest.sh"

  end

  config.vm.define "test" do |test|
    test.vm.provision "shell", inline: "yum -y install git ruby-devel tree"
    test.vm.provision "shell", inline: "gem install puppet-moddeps"
    test.vm.provision "shell", inline: "git clone https://github.com/puppetlabs/puppetlabs-apache.git /etc/puppet/modules/apache"
    test.vm.provision "shell", inline: "puppet-moddeps apache"
  end
end
