# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet/moddeps/version'

Gem::Specification.new do |spec|
  spec.name          = "puppet-moddeps"
  spec.version       = Puppet::Moddeps::VERSION
  spec.authors       = ["GeneBean"]
  spec.email         = ["me@technicalissues.us"]
  spec.summary       = %q{Installs dependencies for a given Puppet module}
  spec.description   = <<-EOF
    This gem will allow you to pull in all missing dependencies for a given
    Puppet module. This is targeted specifically at private modules that have a
    populated metadata.json file.
  EOF
  spec.homepage      = "https://github.com/genebean/puppet-moddeps"
  #spec.homepage      = "http://rubygems.org/gems/puppet-moddeps"
  spec.license       = "New BSD"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.8.7'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_development_dependency 'guard', '~> 2.10'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-nav', '~> 0.2'
  spec.add_development_dependency 'pry-remote', '~> 0.1'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rspec-nc', '~> 0.2'

  spec.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.1'
end
