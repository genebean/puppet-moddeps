require 'spec_helper'

describe Puppet::Moddeps::InstallDeps do

  before(:all) do
    puts 'Downloading the puppetlabs-apache module...'

    %x(puppet module install puppetlabs-apache --ignore-dependencies)

    @dirs_to_clean = ['apache']

    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG['host_os']) != nil
      @expected_path = %x(puppet config print modulepath).split(';')[0]
    else
      @expected_path = %x(puppet config print modulepath).split(':')[0]
    end

    puts "The expected module path is: #{@expected_path}"
  end

  describe '.initialize(path, deps)' do

    it 'should set the default module path and deps list' do
      base_obj = Puppet::Moddeps::InstallDeps.new

      expect(base_obj.module_path).to eq(@expected_path)
      expect(base_obj.deps).to match_array []
    end

    it 'should use the provided values' do
      base_obj = Puppet::Moddeps::InstallDeps.new('/tmp', ['dep1', 'dep2'])
      expect(base_obj.module_path).to eq('/tmp')
      expect(base_obj.deps).to contain_exactly('dep1', 'dep2')
    end

    it 'should fail when an array is passed to path' do
      expect { Puppet::Moddeps::InstallDeps.new(['dep1', 'dep2']) }.to raise_error(SystemExit, 'The provided path was not a string.' )
    end

    it 'should fail when an string is passed to deps' do
      expect { Puppet::Moddeps::InstallDeps.new('arg1', 'arg2') }.to raise_error(SystemExit, 'The provided dependency list was not an array.' )
    end

  end

  describe '.install(puppet_module) feedback verification' do

    before(:each) do
      @base_object = Puppet::Moddeps::InstallDeps.new
    end

    context 'with no parameters' do
      it 'should print usage info' do
        expect { @base_object.install }.to output(/Usage.*/).to_stdout
      end
    end

    context 'with two or more parameters' do
      it 'should print usage info' do
        expect { @base_object.install('arg1', 'arg2') }.to output(/Usage.*/).to_stdout
      end
    end

    context 'with one parameter' do
      it 'should print usage if multiple arguments come in as an array' do
        params = ['arg1', 'arg2']
        expect { @base_object.install(params) }.to output(/Usage.*/).to_stdout
      end

      it 'should print usage if an empty array is passed in' do
        params = []
        expect { @base_object.install(params) }.to output(/Usage.*/).to_stdout
      end

      it 'should fail if the parameter is not an installed module' do
        expect { @base_object.install('fake_missing_module') }.to output(/Can\'t find fake_missing_module in.*/).to_stdout
      end

    end

  end

  describe '.path_separator' do

    subject { Puppet::Moddeps::InstallDeps.new }

    context 'on Windows' do
      it 'should return ; as the path separator' do
        expect(subject.path_separator('mingw32')).to eq(';')
      end
    end

    context 'on Linux' do
      it 'should return : as the path separator' do
        expect(subject.path_separator('linux-gnu')).to eq(':')
      end
    end
  end

  describe '.parse_metadata' do

    it "should parse metadata.json" do
      base_object = Puppet::Moddeps::InstallDeps.new

      base_object.parse_metadata('apache')

      expect(base_object.deps).to contain_exactly('puppetlabs-stdlib', 'puppetlabs-concat')
    end

  end

  describe '.install_modules' do

    before(:all) do
      @base_object = Puppet::Moddeps::InstallDeps.new
    end

    it 'should say the module is already installed' do
      @base_object.instance_variable_set(:@deps, ['apache'])

      expect { @base_object.install_modules }.to output(/apache is already installed.*/).to_stdout
    end

    it 'should say nothing to install' do
      @base_object.instance_variable_set(:@deps, [])

      expect { @base_object.install_modules }.to output(/No dependencies were marked for installation.*/).to_stdout
    end

  end

  describe '.install actual Puppet modules' do

     it "should install each module in provided array" do
       base_object = Puppet::Moddeps::InstallDeps.new

       base_object.install('apache')

       basedir = base_object.module_path

       base_object.deps.each do |dep|
         mod_dir = dep.split('-')[1]
         @dirs_to_clean.push(mod_dir)

         mod_path = "#{basedir}/#{mod_dir}"
         expect(File.directory?(mod_path)).to eql(true)
       end

     end

  end

  after(:all) do

    @dirs_to_clean.each do |mod_dir|
      path_to_clean = @expected_path + "/#{mod_dir}"

      if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG['host_os']) != nil
        puts "Removing #{path_to_clean.gsub '/', '\\'}"
        %x(rmdir /Q /S #{path_to_clean.gsub '/', '\\'})
      else
        puts "Removing #{path_to_clean}"
        %x(rm -rf #{path_to_clean})
      end

    end
  end

end
