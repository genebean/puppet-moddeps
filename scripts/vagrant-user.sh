#!/bin/bash

## This script should be executed as the vagrant user

if [ -f '/vagrant/GitConfig' ]; then
  cp /vagrant/GitConfig ~/.gitconfig
fi

# Setup RVM
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -L get.rvm.io | bash -s stable
source ~/.profile

# Setup Ruby 1.9.3
rvm install 1.9.3
rvm use 1.9.3

# Setup project
gem install bundler --no-ri --no-rdoc
cd puppet-moddeps
bundle install
