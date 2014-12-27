require 'puppet/moddeps/version'
require 'rubygems'
require 'json'

module Puppet
  module Moddeps

    @@default_module_path = '/etc/puppet/modules'
    
    def Moddeps.installDeps(*puppet_module)
      if ( puppet_module.nil? or puppet_module.size == 0 or puppet_module.size > 1)
        Moddeps.help
      end
    end
    
    def Moddeps.help
      puts 'Usage: puppet-moddeps module'
      puts '       Call puppet-moddeps with the name of one installed module'
    end

    def Moddeps.installModuleDependencies(puppet_module)

      @puppet_module = puppet_module
      @metadata      = File.read("#{@@default_module_path}/#{@puppet_module}/metadata.json")
      @data          = JSON.parse(@metadata)

      @data['dependencies'].each do |dep|
        @note    = 'Installing dependency'
        @depname = dep["name"].sub '/', '-'
        @cmd     = "puppet module install #{@depname}"
        puts "#{@cmd}"
        exec("#{@cmd}")
      end
    end

  end
end

