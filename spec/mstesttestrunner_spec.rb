require 'spec_helper'
require 'albacore/mstesttestrunner'

shared_context "mstest paths" do
  before :all do
    @mstestpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'MSTest-2010', 'mstest.exe')
    @test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'mstest', 'TestSolution.MSTestTests.NET40.dll')
    @test_option = "/test:Test /noisolation /noresults"
  end
end

describe MSTestTestRunner, "the command parameters for an mstest runner" do
  include_context "mstest paths"

  before :all do
    mstest = MSTestTestRunner.new(@mstestpath)
    mstest.assemblies @test_assembly
    mstest.options @test_option
    mstest.tests 'APassingTest', 'AFailingTest'
    
    @command_parameters = mstest.get_command_parameters
  end
    
  it "should not include the path to the command" do
    @command_parameters.should_not include(@mstestpath)
  end
  
  it "should include the list of assemblies" do
    @command_parameters.should include("/testcontainer:\"#{@test_assembly}\"")
  end

  it "should include the specific set of tests" do
    @command_parameters.should include("/test:APassingTest /test:AFailingTest")
  end
  
  it "should include the list of options" do
    @command_parameters.should include(@test_option)
  end
end

describe MSTestTestRunner, "the command line string for an mstest runner" do
  include_context "mstest paths"

  before :all do
    mstest = MSTestTestRunner.new(@mstestpath)
    mstest.assemblies @test_assembly
    
    @command_line = mstest.get_command_line
    @command_parameters = mstest.get_command_parameters.join(" ")
  end
    
  it "should start with the path to the command" do
    @command_line.split(" ").first.should == @mstestpath
  end
  
  it "should include the command parameters" do
    @command_line.should include(@command_parameters)
  end
end


describe MSTestTestRunner, "when configured correctly" do
  include_context "mstest paths"

  before :all do
    mstest = MSTestTestRunner.new(@mstestpath)
    mstest.extend(FailPatch)
    mstest.assemblies @test_assembly
    mstest.log_level = :verbose
    mstest.options "/noisolation /noresults"
    mstest.tests "APassingTest"
    mstest.execute
  end
  
  it "should execute" do
    $task_failed.should be_false
  end
end

describe MSTestTestRunner, "when configured correctly, but a test fails" do
  include_context "mstest paths"

  before :all do
    mstest = MSTestTestRunner.new(@mstestpath)
    mstest.extend(FailPatch)
    mstest.assemblies @test_assembly
    mstest.log_level = :verbose
    mstest.options "/noisolation /noresults"
    mstest.tests "AFailingTest"
    mstest.execute
  end

  it "should fail" do
    $task_failed.should be_true
  end
end

describe MSTestTestRunner, "when using the configuration command and not providing a command in the intializer" do
  include_context "mstest paths"

  before :all do
    Albacore.configure do |config|
      config.mstest.command = "configured command"
    end
    @mstest = MSTestTestRunner.new
  end

  it "should use the configuration command" do
    @mstest.command.should == "configured command"
  end
end

describe MSTestTestRunner, "when the command has been set through configuration and providing a command in the intializer" do
  include_context "mstest paths"

  before :all do
    Albacore.configure do |config|
      config.mstest.command = "configured command"
    end
    @mstest = MSTestTestRunner.new("initializer command")
  end

  it "should use the initializer command" do
    @mstest.command.should == "initializer command"
  end
end

describe MSTestTestRunner, "when configuration has been provided" do
  before :all do
    Albacore.configure do |config|
      config.mstest do |mstest|
        mstest.assemblies = ["foo.dll", "bar.dll"]
        mstest.options = ["/test"]
      end
    end

    @mstest = MSTestTestRunner.new
  end

  it "should use the provided configuration" do
    @mstest.assemblies.should == ["foo.dll", "bar.dll"]
    @mstest.options.should == ["/test"]
  end
end
