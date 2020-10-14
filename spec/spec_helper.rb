require 'simplecov'
require 'codecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Codecov
])
SimpleCov.start

require 'pry'
require 'puppet/moddeps'
require 'rbconfig'
require 'semantic_puppet'
