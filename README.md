# Puppet::Moddeps

[![Gem](https://img.shields.io/gem/v/puppet-moddeps)](https://rubygems.org/gems/puppet-moddeps)
[![Actions Status](https://github.com/genebean/puppet-moddeps/workflows/Rspec%20Tests/badge.svg)](https://github.com/genebean/puppet-moddeps/actions)
[![codecov](https://codecov.io/gh/genebean/puppet-moddeps/branch/master/graph/badge.svg?token=9sn4KbY0yu)](https://app.codecov.io/gh/genebean/puppet-moddeps)
![GitHub](https://img.shields.io/github/license/genebean/puppet-moddeps)

## Description

This gem will allow you to pull in all missing dependencies for a given Puppet module by running `puppet-moddeps some_module`. This is targeted specifically at private modules or modules cloned from GitHub that have a populated `metadata.json` file. It really shines as a tool to install all the dependencies of a module that you have just created or when you have just updated the list of dependencies in a module's `metadata.json` file.

## Installation

puppet-moddeps has been extensively tested using the ruby bundled with the Puppet agent. The recommended way to use this gem is to first install puppet and then open an elevated command prompt and run this:

```bash
puppet resource package puppet-moddeps provider=puppet_gem ensure=latest
```

Alternatively, you can also install it using another instance of Ruby so long as it is at least version 2.5.7.

## Usage

After installation, you can run `puppet-moddeps some_module`, replacing `some_module` with the name of any module installed in `/etc/puppetlabs/code/environments/production/modules/`. It will resolve the module's dependencies based on its `metadata.json` file and install each of them.

### Using in a module's Vagrantfile

If your module includes a [`Vagrantfile`](https://www.vagrantup.com/docs/vagrantfile) you can utilize this gem as part of your provisioning step by adding this to it:

```ruby
MODULE_NAME='some_module'
Vagrant.configure('2') do |config|
  config.vm.box = 'genebean/centos-7-puppet-latest' # Any box that includes Puppet will work here
  config.vm.provision 'shell', inline: <<-SCRIPT
    puppet resource file /etc/puppetlabs/code/environments/production/modules/#{MODULE_NAME} ensure=link target=/vagrant force=true
    /opt/puppetlabs/puppet/bin/gem install puppet-moddeps
    /opt/puppetlabs/puppet/bin/puppet-moddeps #{MODULE_NAME}
  SCRIPT
end
```

## Contributing

Pull requests are welcome!

1. Fork it ( https://github.com/genebean/puppet-moddeps/fork )
2. Create a feature branch
3. Install bundler (`gem install bundler`)
4. Install development gems (`bundle install`)
5. Open a second terminal and use guard to make sure your code doesn't break anything (`bundle exec guard -p`)
6. Commit your changes and associated tests (`git commit -am 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create a new pull request

### Vagrant

Development and testing can also be done utilizing the included `Vagrantfile`.
To do so, install [Vagrant][vagrant] and [VirtualBox][vbox], fork and clone the
project, cd into the project, and run `vagrant up` followed by `vagrant ssh`.
The setup process will take care of running `bundle install` for you. You
can find the code symlinked into the vagrant user's home directory. Also, RVM
is installed system-wide in the referenced Vagrant box.

### Tests

Please try and write tests using Rspec's expect syntax for any code you add or change.
Code must have tests before it will be merged.

## License

This code is released under the Apache 2.0 license. A copy is in the LICENSE file in this repo.

[rvm]: http://rvm.io
[vbox]: https://www.virtualbox.org
[vagrant]: https://www.vagrantup.com
