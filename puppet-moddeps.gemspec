# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet/moddeps/version'

Gem::Specification.new do |spec|
  spec.name          = "puppet-moddeps"
  spec.version       = Puppet::Moddeps::VERSION
  spec.authors       = ["GeneBean"]
  spec.email         = ["gene@technicalissues.us"]
  spec.summary       = %q{Installs dependencies for a given Puppet module}
  spec.description   = <<-EOF
    This gem will allow you to pull in all missing dependencies for a given
    Puppet module. This is targeted specifically at private modules that have a
    populated metadata.json file.
  EOF
  spec.homepage      = "https://github.com/genebean/puppet-moddeps"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.5.7'

  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4'
  spec.add_development_dependency 'codecov', '~> 0.4.3'
  spec.add_development_dependency 'guard', '~> 2.16', '>= 2.16.2'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'guard-yard', '~> 2.2', '>= 2.2.1'
  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'pry-remote', '~> 0.1.8'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.1'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rspec-nc', '~> 0.3.0'
  spec.add_development_dependency 'wdm', '~> 0.1.1' if Gem.win_platform?
  spec.add_development_dependency 'yard', '~> 0.9.25'

  if ENV.key?('PUPPET_VERSION')
    puppetversion = "= #{ENV['PUPPET_VERSION']}"
  else
    puppetversion = ['>= 6.0', '< 7.0']
  end
  spec.add_development_dependency 'puppet', puppetversion

  spec.add_runtime_dependency 'json', '~> 2.3', '>= 2.3.1'
  spec.add_runtime_dependency 'puppetfile-resolver', '~> 0.4.0'
end
