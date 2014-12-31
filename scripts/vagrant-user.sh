#!/bin/bash

## This script should be executed as the vagrant user

if [ -f '/vagrant/GitConfig' ]; then
  cp /vagrant/GitConfig ~/.gitconfig
fi

# Setup project
gem install bundler --no-ri --no-rdoc
cd puppet-moddeps
bundle install --jobs=3 --retry=3
