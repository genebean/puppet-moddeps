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
  spec.homepage      = "https://github.com/genebean/puppet-moddeps"
  #spec.homepage      = "http://rubygems.org/gems/puppet-moddeps"
  spec.license       = "New BSD"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "coveralls" # requires ruby >= 1.9.2
  spec.add_development_dependency "guard"     # requires ruby >= 1.9.2
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"

  spec.add_runtime_dependency "json"
end

