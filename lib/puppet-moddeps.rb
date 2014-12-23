require 'rubygems'
require 'json'

class PuppetModdeps

  @@default_module_path = '/etc/puppet/modules'

  def self.installModuleDependencies(puppet_module)

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

