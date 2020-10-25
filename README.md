# Puppet::Moddeps

[![Gem Version][gem-v-img]][gem-version]
[![Actions Status](https://github.com/genebean/puppet-moddeps/workflows/Rspec%20Tests/badge.svg)](https://github.com/genebean/puppet-moddeps/actions)
[![codecov](https://codecov.io/gh/genebean/puppet-moddeps/branch/master/graph/badge.svg?token=9sn4KbY0yu)](https://app.codecov.io/gh/genebean/puppet-moddeps)

## Description

This gem will allow you to pull in all missing dependencies for a given Puppet
module. This is targeted specifically at private modules or modules cloned from
GitHub that have a populated `metadata.json` file.

puppet-moddeps has been extensively tested on CentOS 6 using the system ruby
(v1.8.7). Due to dependency requirements all development is done on ruby 1.9.3
or higher. Automated testing of v1.8.7 cannot be done on Travis-CI due to the
development dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puppet-moddeps'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puppet-moddeps

## Usage

To put this gem to use just install it and run `puppet-moddeps some_module`,
replacing `some_module` with the name of any module installed in
`/etc/puppet/modules`. It will parse the module's `metadata.json` file pull down
it's listed dependencies.

## Contributing

The development environment requires at least Ruby 1.9.2 due to the use of Guard
and Coveralls.  The gem is designed to run on Ruby 1.8.7 and higher as that is
the version available in Red Hat / CentOS 6.

1. Fork it ( https://github.com/genebean/puppet-moddeps/fork )
2. Create your feature branch based off of the develop branch
   (`git checkout develop; git checkout -b my-new-feature`)
3. Install development gems (`bundle install`)
4. Open a second terminal and use guard to make sure your code doesn't break anything
   (`bundle exec guard`)
5. Commit your changes and associated tests (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request

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


[coveralls-master]: https://coveralls.io/r/genebean/puppet-moddeps?branch=master
[coveralls-develop]: https://coveralls.io/r/genebean/puppet-moddeps?branch=develop
[coveralls-img-master]: https://img.shields.io/coveralls/genebean/puppet-moddeps/master.svg
[coveralls-img-develop]: https://img.shields.io/coveralls/genebean/puppet-moddeps/develop.svg
[gem-v-img]: https://badge.fury.io/rb/puppet-moddeps.svg
[gem-version]: http://badge.fury.io/rb/puppet-moddeps
[rvm]: http://rvm.io
[travis-ci]: https://travis-ci.org/genebean/puppet-moddeps
[travis-img-master]: https://img.shields.io/travis/genebean/puppet-moddeps/master.svg
[travis-img-develop]: https://img.shields.io/travis/genebean/puppet-moddeps/develop.svg
[vbox]: https://www.virtualbox.org
[vagrant]: https://www.vagrantup.com
