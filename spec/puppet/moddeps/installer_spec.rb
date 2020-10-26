require 'spec_helper'

describe Puppet::Moddeps::Installer do

  before(:all) do
    if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG['host_os']) != nil
      @expected_path = %x(puppet config print modulepath).split(';')[0].strip
    else
      @expected_path = %x(puppet config print modulepath).split(':')[0].strip
    end
  end

  describe '.initialize(module_path, puppet_version)' do
    it 'should set the default module path and puppet version' do
      base_obj = Puppet::Moddeps::Installer.new

      expect(base_obj.module_path).to eq(@expected_path)
      expect(base_obj.puppet_version).to be_nil
    end

    it 'should use the provided values' do
      base_obj = Puppet::Moddeps::Installer.new('/tmp', '6.18.0')
      expect(base_obj.module_path).to eq('/tmp')
      expect(base_obj.puppet_version).to eq('6.18.0')
    end

    it 'should fail when an array is passed to path' do
      expect {
        Puppet::Moddeps::Installer.new(['path1', 'path2'])
      }.to raise_error(SystemExit, 'The provided module path was not a string.' )
    end

    it 'should fail when an array is passed to puppet_version' do
      expect {
        Puppet::Moddeps::Installer.new('/tmp', ['arg1', 'arg2'])
      }.to raise_error(SystemExit, 'The provided puppet version was not a string.' )
    end
  end

  describe '.install(puppet_module) feedback verification' do
    before(:each) do
      @base_object = Puppet::Moddeps::Installer.new
    end

    context 'with no parameters' do
      it 'should print usage info' do
        expect { @base_object.install }.to raise_error(SystemExit, /Usage.*/)
      end
    end

    it 'should print usage if an element of the array is not a string' do
      allow(@base_object).to receive(:installed?).and_return(true)
      expect { @base_object.install(['arg1', ['arg2']]) }.to raise_error(SystemExit, /Usage.*/)
      expect { @base_object.install([['arg1'], 'arg2']) }.to raise_error(SystemExit, /Usage.*/)
      expect { @base_object.install([{'arg1' => 'arg2'}]) }.to raise_error(SystemExit, /Usage.*/)
    end

    it 'should print usage if an empty array is passed in' do
      params = []
      expect { @base_object.install(params) }.to raise_error(SystemExit, /Usage.*/)
    end

    it 'should fail if the parameter is not an installed module' do
      expect { @base_object.install(['fake_missing_module']) }.to raise_error(SystemExit, /Can\'t find fake_missing_module in.*/)
    end
  end

  describe '.path_separator' do

    subject { Puppet::Moddeps::Installer.new }

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

  describe '.install Puppet modules' do
     it "should install dependencies for a single module" do
       base_object = Puppet::Moddeps::Installer.new
       module_to_install = Puppet::Moddeps::Module.new("genebean", "foo", "1.2.3")
       allow(base_object).to receive(:installed?).and_return(true)
       allow(base_object).to receive(:module_versions_match?).and_return(false)

       # return a single module to install
       allow(base_object).to receive(:resolve_local_module_deps).and_return([module_to_install])
       allow(base_object).to receive(:call_puppet)

       base_object.install(['apache'])

       # validate that only the returned modules is installed
       expect(base_object).to have_received(:call_puppet).once
       expect(base_object).to have_received(:call_puppet).once.with(module_to_install)
     end

     it "should install dependencies for multiple modules" do
       base_object = Puppet::Moddeps::Installer.new
       first_module_to_install = Puppet::Moddeps::Module.new("genebean", "foo", "1.2.3")
       second_module_to_install = Puppet::Moddeps::Module.new("genebean", "bar", "4.5.6")
       allow(base_object).to receive(:installed?).and_return(true)
       allow(base_object).to receive(:module_versions_match?).and_return(false)

       # return two modules to install
       allow(base_object).to receive(:resolve_local_module_deps).and_return([first_module_to_install, second_module_to_install])
       allow(base_object).to receive(:call_puppet)

       base_object.install(['apache', 'nginx'])

       # validate that only the two returned modules get installed
       expect(base_object).to have_received(:call_puppet).twice
       expect(base_object).to have_received(:call_puppet).once.with(first_module_to_install)
       expect(base_object).to have_received(:call_puppet).once.with(second_module_to_install)
     end
  end
end
