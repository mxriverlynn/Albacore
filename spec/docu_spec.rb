require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/docu'
require 'docu_patch'

describe Docu, "when building docs without any assemblies specified" do  
  before :all do
    @docu = Docu.new
    @docu.execute
  end

  it "should fail with a missing assemblies message" do
    @docu.failed.should be_true
    @docu.failure_message.should eql('Docu Failed. No assemblies specified')
  end
end

describe Docu, "when building docs fails" do  
  before :all do
    @docu = Docu.new
    @docu.command_result = false
    @docu.assemblies 'test.dll'
    @docu.execute
  end

  it "should fail with a generic message" do
    @docu.failed.should be_true
    @docu.failure_message.should eql('Docu Failed. See Build Log For Detail')
  end
end

describe Docu, "when building docs with assemblies specified" do
  before :all do
    @docu = Docu.new
    @docu.command_result = true
    @docu.assemblies 'test.dll'
    @docu.execute
  end
  
  it "should pass the assemblies in the command-line arguments" do
    @docu.command_parameters.should include('test.dll')
  end
end

describe Docu, "when building docs with assemblies and xml files specified" do
  before :all do
    @docu = Docu.new
    @docu.command_result = true
    @docu.xml_files 'test.xml'
    @docu.assemblies 'test.dll'
    @docu.execute
  end
  
  it "should pass the xml files in the command-line arguments after the assemblies" do
    @docu.command_parameters.should include('test.dll test.xml')
  end
end

describe Docu, "when building docs with an output location specified" do
  before :all do
    @docu = Docu.new
    @docu.command_result = true
    @docu.assemblies 'test.dll'
    @docu.output_location = 'output_location'
    @docu.execute
  end
  
  it "should pass the output location using the --output switch" do
    @docu.command_parameters.should include('--output="output_location"')
  end
end