require 'spec_helper'

describe Puppet::Moddeps do

  describe ".installModuleDependencies('ntp')" do

    before do 
      Puppet::Moddeps.installModuleDependencies('ntp')
    end

    it "installs ntp's only dependency: stdlib" do
      expect(obj).to exist('/etc/puppet/modules/stdlib')
    end

  end

end

