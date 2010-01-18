require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/xunittestrunner'

@@xunitpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'XUnit-v1.5', 'xunit.console.exe')
@@test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'xunit', 'assemblies', 'TestSolution.XUnitTests.dll')
@@output_option = "/out=xunit.results.html"

describe XUnitTestRunner, "the command parameters for an xunit runner" do
  before :all do
    xunit = XUnitTestRunner.new(@@xunitpath)
    xunit.assembly = @@test_assembly
    xunit.options @@output_option
    
    @command_parameters = xunit.get_command_parameters
  end
    
  it "should not include the path to the command" do
    @command_parameters.should_not include(@@xunitpath)
  end
  
  it "should include the list of assemblies" do
    @command_parameters.should include("\"#{@@test_assembly}\"")
  end
  
  it "should include the list of options" do
    @command_parameters.should include(@@output_option)
  end
end

describe XUnitTestRunner, "the command line string for an xunit runner" do
  before :all do
    xunit = XUnitTestRunner.new(@@xunitpath)
    xunit.assembly = @@test_assembly
    xunit.options @@output_option
    
    @command_line = xunit.get_command_line
    @command_parameters = xunit.get_command_parameters.join(" ")
  end
    
  it "should start with the path to the command" do
    @command_line.split(" ").first.should == @@xunitpath
  end
  
  it "should include the command parameters" do
    @command_line.should include(@command_parameters)
  end
end


describe XUnitTestRunner, "when configured correctly" do
  before :all do
    xunit = XUnitTestRunner.new(@@xunitpath)
    xunit.assembly = @@test_assembly
    xunit.options '/noshadow'
    
    xunit.execute
    @failed = xunit.failed
  end
  
  it "should execute" do
    @failed.should be_false
  end
end