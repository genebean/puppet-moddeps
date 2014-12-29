#!/bin/bash

wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
rm -f puppetlabs-release-precise.deb
apt-get update -qq
apt-get install -y puppet > /dev/null
