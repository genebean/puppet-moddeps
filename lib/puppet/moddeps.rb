require 'puppet/moddeps/version'
require 'rubygems'
require 'json'

module Puppet
  module Moddeps

    @@default_module_path = '/etc/puppet/modules'
    
    def Moddeps.installDeps(*puppet_module)
      if ( puppet_module.size == 1)
        if Moddeps.checkIfInstalled(puppet_module[0])
          Moddeps.parseMetadata(puppet_module[0])
          Moddeps.installModules
        else
          puts "Can't find #{puppet_module[0]} in #{@@default_module_path}"
        end
      else
        Moddeps.help
      end
    end
    
    def Moddeps.help
      puts 'Usage: puppet-moddeps module'
      puts '       Call puppet-moddeps with the name of one installed module'
    end
    
    def Moddeps.checkIfInstalled(file)
      File.directory?("#{@@default_module_path}/#{file}")
    end
    
    def Moddeps.parseMetadata(puppet_module)
      metadata = File.read("#{@@default_module_path}/#{puppet_module}/metadata.json")
      data     = JSON.parse(metadata)
      @deps    = Moddeps.getDeps(data)
    end
    
    def Moddeps.getDeps(data)
      dependencies = []
      data['dependencies'].each do |dep|
        depname = dep["name"].sub '/', '-'
        dependencies.push( depname )
      end
      
      return dependencies
    end
    
    def Moddeps.installModules
      if @deps.size > 0
        @deps.each do |dep|
          if Moddeps.checkIfInstalled(dep)
            puts "#{dep} is already installed, skipping."
          else
            cmd = "/usr/bin/puppet module install #{dep}"
            puts "Running \"#{cmd}\"..."
            %x(#{cmd})
          end
        end
      else
        puts 'No dependencies were marked for installation.'
      end
    end

  end
end

