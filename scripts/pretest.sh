#!/bin/bash

moddir="`puppet config print modulepath | cut -d ':' -f1`"
modname='fake_private_module'

if [ -d "$moddir/$modname" ]; then rm -rf "$moddir"; fi

mkdir -p "$moddir/$modname"

chmod -R 775 "$moddir/$modname"

cat > "$moddir/$modname/metadata.json" <<EOF
{
  "dependencies": [
    {"name":"puppetlabs/stdlib","version_requirement":">= 2.4.0"},
    {"name":"puppetlabs/concat","version_requirement":">= 1.1.1"},
    {"name":"puppetlabs/firewall","version_requirement":">= 1.3.0"}
  ],
}

EOF
