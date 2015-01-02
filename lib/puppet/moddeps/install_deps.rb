require 'rubygems'
require 'json'
require 'rbconfig'

module Puppet
  module Moddeps
    class InstallDeps

      attr_reader :module_path, :deps

      def initialize(path=nil, deps=nil)
        if path and path.is_a?(String)
          @module_path = path
        elsif path
          abort('The provided path was not a string.')
        else
          separator = self.path_separator(RbConfig::CONFIG['host_os'])
          @module_path = %x(puppet config print modulepath).split(separator)[0]
        end

        if deps and deps.is_a?(Array)
          @deps = deps
        elsif deps
          abort('The provided dependency list was not an array.')
        else
          @deps = []
        end
      end

      def install(*puppet_module)

        if puppet_module.size >=1 and puppet_module[0].is_a?(Array)
          args = puppet_module[0]
        else
          args = puppet_module
        end

        if args.size == 1
          if installed?(args[0])
            self.parse_metadata(args[0])
            self.install_modules
          else
            puts "Can't find #{args[0]} in #{@module_path}"
          end
        else
          self.help
        end
      end

      def help
        puts 'Usage: puppet-moddeps module'
        puts '       Call puppet-moddeps with the name of one installed module'
      end

      def installed?(module_name)
        File.directory?("#{@module_path}/#{module_name}")
      end

      def path_separator(os_string)
        if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ os_string) != nil
          separator = ';'
        else
          separator = ':'
        end
      end

      def parse_metadata(module_name)
        metadata = File.read("#{@module_path}/#{module_name}/metadata.json")
        data     = JSON.parse(metadata)
        self.parse_deps(data)
      end

      def parse_deps(data)
        @deps.clear

        data['dependencies'].each do |dep|
          depname = dep["name"].sub '/', '-'
          @deps.push( depname )
        end
      end

      def install_modules
        if @deps.size > 0

          puts "Modules will be installed into #{module_path}"

          @deps.each do |dep|
            if self.installed?(dep)
              puts "#{dep} is already installed, skipping."
            else
              cmd = "puppet module install #{dep}"
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
end
