require 'puppet/moddeps/version'
require 'rubygems'
require 'json'

module Puppet
  module Moddeps
    class InstallDeps

      attr_reader :default_module_path, :deps

      def initialize(*puppet_module)
        @default_module_path = '/etc/puppet/modules'
        @deps = []

        if puppet_module.size >=1 and puppet_module[0].is_a?(Array)
          args = puppet_module[0]
        else
          args = puppet_module
        end

        if args.size == 1
          if check_if_installed(args[0])
            self.parse_metadata(args[0])
            self.install_modules
          else
            puts "Can't find #{args[0]} in #{@default_module_path}"
          end
        else
          self.help
        end
      end

      def help
        puts 'Usage: puppet-moddeps module'
        puts '       Call puppet-moddeps with the name of one installed module'
      end

      def check_if_installed(file)
        File.directory?("#{@default_module_path}/#{file}")
      end

      def parse_metadata(puppet_module)
        metadata = File.read("#{@default_module_path}/#{puppet_module}/metadata.json")
        data     = JSON.parse(metadata)
        @deps    = self.get_deps(data)
      end

      def install_modules
        if @deps.size > 0
          @deps.each do |dep|
            if self.check_if_installed(dep)
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

      private

      def get_deps(data)
        dependencies = []
        data['dependencies'].each do |dep|
          depname = dep["name"].sub '/', '-'
          dependencies.push( depname )
        end

        return dependencies
      end

    end
  end
end
