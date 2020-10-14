# Change Log for Puppet::Moddeps

[![GitHub tag][tag-img]][tag] [![Gem Version][gem-v-img]][gem-version]

## v2.0.0

* Rewrote to be more intelligent by using puppetfile-resolver

## v1.1.0

* converted to a class-based code structure
* removed Gemfile.lock for flexibility of using dynamic Puppet versions for
  testing
* improved testablilty and fixed it so that all test pass

## v1.2.0

* created this changelog
* simplified vagrant setup
* updated documentation
* fixed bug preventing reporting test results to multiple places
* adjusted testing code for Windows - builds should work just as on Linux



[gem-v-img]: https://badge.fury.io/rb/puppet-moddeps.svg
[gem-version]: http://badge.fury.io/rb/puppet-moddeps
[tag]: https://github.com/genebean/puppet-moddeps
[tag-img]: https://img.shields.io/github/tag/genebean/puppet-moddeps.svg
