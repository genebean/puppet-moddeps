require 'json'
require 'puppetfile-resolver'
require 'puppet/moddeps/module'

module Puppet
  module Moddeps
    class Installer

      # The path to which modules will be installed
      #
      # @return [String]
      #   The path to which modules will be installed
      attr_reader :module_path

      # The version of Puppet that will be used when resolving dependencies.
      # If none is provided then a Puppet version constraint is not applied
      # during resolution.
      #
      # @return [String]
      #   The version of Puppet that will be used when resolving dependencies
      #   if one was specified.
      attr_reader :puppet_version

      # Creates an instance of Puppet::Moddeps::Installer
      #
      # @param module_path [String]
      #   The path to which modules will be installed
      # @param puppet_version [String]
      #   The verion of Puppet to use when resolving dependencies
      #
      # @example No parameters
      #   depinstaller = Puppet::Moddeps::Installer.new
      #
      # @example Specify a module path
      #   depinstaller = Puppet::Moddeps::Installer.new('/tmp')
      #
      # @example Specify a module path and a Puppet version
      #   depinstaller = Puppet::Moddeps::Installer.new('/tmp', '6.18.0')
      #
      def initialize(module_path=nil, puppet_version=nil)
        if module_path
          abort('The provided module path was not a string.') unless module_path.is_a?(String)
          @module_path = module_path
        else
          separator = self.path_separator(RbConfig::CONFIG['host_os'])
          @module_path = %x(puppet config print modulepath).split(separator)[0].strip
        end

        if puppet_version
          abort('The provided puppet version was not a string.') unless puppet_version.is_a?(String)
        end

        @puppet_version = puppet_version

        @usage = <<~ENDUSAGE
          Usage: puppet-moddeps module_one [module_two] [...]
                 Call puppet-moddeps with the name of one or more installed modules'
        ENDUSAGE
      end

      # Installs the dependencies for one or more local modules. This is the
      # primary entry point for this class.
      #
      # @param puppet_module [Array[String]]
      #   An array of strings representig the names of one or more locally
      #   installed puppet modules.
      #
      # @example Install dependencies for one module
      #   depinstaller.install(['apache'])
      #
      # @example Install dependencies for multiple module
      #   depinstaller.install(['apache', 'nginx'])
      def install(*puppet_module)
        # puppet_module will always be an array.
        # The elements of the array are the values passed in.
        if puppet_module.nil? || puppet_module.size == 0 || puppet_module[0].nil? || puppet_module[0].size == 0
          puts 'input problem'
          abort(@usage)
        end

        module_array = puppet_module[0]

        # The intent is to only accept strings as arguments.
        # It is also expected that all arguments are installed modules
        module_array.each do |mod|
          abort(@usage) unless mod.is_a?(String)
          abort("Can't find #{mod} in #{@module_path}") unless self.installed?(mod)
        end

        module_objects = resolve_local_module_deps(module_array)
        
        # Remove the local modules from the list of modules to install
        # so that the installation process does not overwrite whatever
        # initiated running puppet-moddeps.
        module_objects.each do |obj|
          if module_array.include?(obj.name)
            module_objects.delete(obj)
          end
        end

        # install the needed modules
        self.install_modules(module_objects)
      end

      # Test to see if a module's folder is present within the module path.
      #
      # @param module_name [String]
      #   The name of a module
      #
      # @return [Boolean]
      #   Returns true if found, false otherwise
      def installed?(module_name)
        File.directory?("#{@module_path}/#{module_name}")
      end

      # Determine the character used to separate entries in an operating
      # system's path environment variable.
      #
      # @param os_string [String]
      #   A string representing a host's operating system as returned
      #   by RbConfig::CONFIG['host_os']
      #
      # @return [String]
      #   Returns ";" on Windows and ":" on everything else
      def path_separator(os_string)
        if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ os_string) != nil
          separator = ';'
        else
          separator = ':'
        end
      end

      # Resolves the dependencies of one or more locally installed modules
      #
      # @param modules [Array[String]]
      #   An array of module names
      #
      # @return [Array[Puppet::Moddeps::Module]]
      #   An array of module objects representing the modules that need
      #   to be installed to satisfiy the dependencies of the local module(s)
      def resolve_local_module_deps(modules)
        # Build the document model from the modules.
        model = PuppetfileResolver::Puppetfile::Document.new('')

        modules.each do |mod|
          model.add_module(
            PuppetfileResolver::Puppetfile::LocalModule.new(mod)
          )
        end

        # Make sure the Puppetfile model is valid.
        unless model.valid?
          raise "Unable to resolve dependencies for modules: #{modules.map(&:title).join(', ')}"
        end

        resolver = PuppetfileResolver::Resolver.new(model, @puppet_version)

        # Configure and resolve the dependency graph, catching any errors
        # raised by puppetfile-resolver and re-raising them as Bolt errors.
        begin
          result = resolver.resolve(
            cache:                 nil,
            ui:                    nil,
            module_paths:          [@module_path],
            allow_missing_modules: false
          )
        rescue StandardError => e
          raise e.message
        end

        # Turn specifications into module objects. This will skip over anything that is not
        # a module specification (i.e. a Puppet version specification).
        module_objects = result.specifications.each_with_object(Set.new) do |(_name, spec), acc|
          next unless spec.instance_of? PuppetfileResolver::Models::ModuleSpecification
          acc << Puppet::Moddeps::Module.new(spec.owner, spec.name, spec.version.to_s)
        end
      end

      # Installs requested modules if they are not already installed.
      #
      # @param module_objects [Array[Puppet::Moddeps::Module]]
      #   An array of module objects representing the modules that need
      #   to be installed
      def install_modules(module_objects)
        if Array(module_objects).size > 0
          puts "Modules will be installed into #{@module_path}"

          Array(module_objects).each do |mod|
            if self.installed?(mod.name) && self.module_versions_match?(mod.owner, mod.name, mod.version)
              puts "#{mod.owner}-#{mod.name} #{mod.version} is already installed, skipping"
            else
              self.call_puppet(mod)
            end
          end
        else
          puts 'No dependencies were marked for installation.'
        end
      end

      # Parses the metadata.json file of a module and returns it as Hash
      #
      # @param module_name [String]
      #   The name of a module
      #
      # @return [Hash]
      #   A hash representing the JSON metadata
      def parse_metadata(module_name)
        metadata = File.read("#{@module_path}/#{module_name}/metadata.json")
        data     = JSON.parse(metadata)
      end

      # Compare the owner, name, and version of an installed module to a
      # provided set of information.
      #
      # @param module_owner [String]
      #   The owner / author of a module. Ex. puppetlabs
      # @param module_name [String]
      #   The name of a module. Ex. apache
      # @param module_version [String]
      #   The semantic version of a module. Ex. 5.6.0
      #
      # @return [Boolean]
      #   Retruns true if the information matches, false otherwise
      def module_versions_match?(module_owner, module_name, module_version)
        metadata = self.parse_metadata(module_name)
        if metadata['author'].eql?(module_owner) && metadata['version'].eql?(module_version)
          return true
        else
          return false
        end
      end

      # Shell out to the puppet binary to install a module without dependencies.
      #
      # @param module_object [Puppet::Moddeps::Module]
      #   A Module object that represents the module to install
      def call_puppet(module_object)
        cmd = "puppet module install --force --ignore-dependencies #{module_object.owner}-#{module_object.name} --version #{module_object.version}"
        puts "Running \"#{cmd}\""
        %x(#{cmd})
      end
    end
  end
end
