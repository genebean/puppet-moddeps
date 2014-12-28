#!/bin/bash

wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
rm -f puppetlabs-release-precise.deb
apt-get update -qq
apt-get install -y puppet > /dev/null
  
chmod 777 /etc/puppet/modules

moddir='/etc/puppet/modules/fake_private_module'

if [ -d "$moddir" ]; then rm -rf "$moddir"; fi

mkdir "$moddir"

cat > "$moddir/metadata.json" <<EOF
{
  "dependencies": [
    { "name":"puppetlabs/stdlib","version_requirement":">= 3.2.0 < 5.0.0" }
  ]
}

EOF
