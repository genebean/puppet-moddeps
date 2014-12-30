require 'codeclimate-test-reporter'
require 'coveralls'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  CodeClimate::TestReporter::Formatter,
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start 'rails'


require 'pry'
require 'puppet/moddeps'
