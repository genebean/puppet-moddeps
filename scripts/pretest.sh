#!/bin/bash

chmod 777 /etc/puppet/modules

moddir='/etc/puppet/modules/fake_private_module'

if [ -d "$moddir" ]; then rm -rf "$moddir"; fi

mkdir "$moddir"

cat > "$moddir/metadata.json" <<EOF
{
  "dependencies": [
    {"name":"puppetlabs/stdlib","version_requirement":">= 2.4.0"},
    {"name":"puppetlabs/concat","version_requirement":">= 1.1.1"},
    {"name":"puppetlabs/firewall","version_requirement":">= 1.3.0"}
  ]
}

EOF
