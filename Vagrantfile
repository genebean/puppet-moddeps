# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "genebean/centos6-puppet-64bit"

  config.vm.synced_folder "./", "/home/vagrant/puppet-moddeps"

  config.vm.provision "shell", inline:   "yum -y install vim-enhanced tree git ruby-devel"
  config.vm.provision "shell", inline:   "su - vagrant -c \"if [ -f '/vagrant/GitConfig' ]; then cp /vagrant/GitConfig ~/.gitconfig; fi\""
  config.vm.provision "shell", inline:   "su - vagrant -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3'"
  config.vm.provision "shell", inline:   "su - vagrant -c 'curl -L get.rvm.io | bash -s stable'"
  config.vm.provision "shell", inline:   "su - vagrant -c 'rvm install 1.9.3; rvm use 1.9.3'"
  config.vm.provision "shell", inline:   "su - vagrant -c 'gem install bundler --no-ri --no-rdoc'"
  #config.vm.provision "shell", inline:   "su - vagrant -c 'cd puppet-moddeps; bundle install --path vendor/bundle'"
  config.vm.provision "shell", inline:   "su - vagrant -c 'cd puppet-moddeps; bundle install --jobs=3 --retry=3 --deployment'"
  config.vm.provision "shell", inline:   "git clone https://github.com/puppetlabs/puppetlabs-ntp.git /etc/puppet/modules/ntp"
  #config.vm.provision "shell", inline:   "su - vagrant -c ''"

end
