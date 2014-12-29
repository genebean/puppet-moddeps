require 'spec_helper'

describe Puppet::Moddeps::InstallDeps do

  describe '.new(puppet_module)' do

    context 'with no parameters' do
      it 'should print usage info' do

        expect { Puppet::Moddeps::InstallDeps.new }.to output(/Usage.*/).to_stdout
      end
    end

    context 'with two or more parameters' do
      it 'should print usage info' do
        expect { Puppet::Moddeps::InstallDeps.new('arg1', 'arg2') }.to output(/Usage.*/).to_stdout
      end
    end

    context 'with one parameter' do
      it 'should print usage if multiple arguments come in as an array' do
        params = ['arg1', 'arg2']
        expect { Puppet::Moddeps::InstallDeps.new(params) }.to output(/Usage.*/).to_stdout
      end

      it 'should print usage if an empty array is passed in' do
        params = []
        expect { Puppet::Moddeps::InstallDeps.new(params) }.to output(/Usage.*/).to_stdout
      end

      it 'should fail if the parameter is not an installed module' do
        expect { Puppet::Moddeps::InstallDeps.new('fake_missing_module') }.to output(/Can\'t find fake_missing_module in.*/).to_stdout
      end

      it "should parse metadata.json" do
        deps = Puppet::Moddeps::InstallDeps.parse_metadata('fake_private_module')
        expect(deps).to include('puppetlabs-stdlib', 'puppetlabs-concat', 'puppetlabs-firewall')
      end

      it "should install each module in provided array" do
        Puppet::Moddeps::InstallDeps.new('fake_private_module')
        basedir = '/etc/puppet/modules'
        expect("#{basedir}/stdlib").to exist
        expect("#{basedir}/concat").to exist
        expect("#{basedir}/firewall").to exist
      end

    end

  end # end describe '.installDeps(puppet_module)'

  #after(:all) do
  #  %x(sudo rm -rf /etc/puppet/modules/*)
  #end

end
