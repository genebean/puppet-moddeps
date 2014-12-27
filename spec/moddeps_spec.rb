require 'spec_helper'

describe Puppet::Moddeps do
  
  describe '.installDeps(puppet_module)' do

    context 'with no parameters' do
      it 'should print usage info' do
        
        expect { Puppet::Moddeps.installDeps() }.to output(/Usage.*/).to_stdout
      end
    end
    
    context 'with two or more parameters' do
      it 'should print usage info' do
        expect { Puppet::Moddeps.installDeps('arg1', 'arg2') }.to output(/Usage.*/).to_stdout
      end
    end
    
    context 'with one parameter' do
      it 'should verify parameter is the name of an installed module' do
        if false
          it "should print usage and exit 1" do
            pending('test for usage being printed')
            pending('verify exit code is 1')
          end
        end
      end
      
      it "should parse metadata.json" do
        pending('create array of deps')
      end
      
      it "should return an array of modules to install" do
        pending('test that an array is returned, even if zero elements')
      end
      
      it "should install each module in provided array" do
        if File.directory?('some module')
          it "it should notify that module exists" do
            pending('test that notification was printed')
          end
          
        else
          pending('test that module was installed')
        end
        
      end
      
    end
    
  end

end

