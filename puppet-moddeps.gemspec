Gem::Specification.new do |s|
  s.name        = 'puppet-moddeps'
  s.version     = '0.1.0'
  s.date        = '2014-12-22'
  s.summary     = "Installs dependencies for a given Puppet module"
  s.authors     = ["GeneBeam"]
  s.email       = 'me@technicalissues.us'

  s.add_runtime_dependency "json"
  #s.add_development_dependency "rspec", "~>2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.homepage    =
    'http://rubygems.org/gems/puppet-moddeps'
  s.license       = 'New BSD'
end
