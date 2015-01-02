require 'codeclimate-test-reporter'
require 'coveralls'
require 'simplecov'

# The order of these is very important for making them all work together.
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter # this has to be last or reporting fails.
]
SimpleCov.start 'rails' # without 'rails' this doesn't work right.


require 'pry'
require 'puppet/moddeps'
require 'rbconfig'