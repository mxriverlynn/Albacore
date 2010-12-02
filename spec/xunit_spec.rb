require 'spec_helper'
require 'albacore/xunittestrunner'

shared_examples_for "xunit paths" do
  before :all do
    @xunitpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'XUnit-v1.5', 'xunit.console.exe')
    @test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'xunit', 'assemblies', 'TestSolution.XUnitTests.dll')
    @output_option = "/out=xunit.results.html"
    @working_dir =File.join(File.dirname(__FILE__), 'support','xunit')
    @html_output = File.join(@working_dir,'TestSolution.XUnitTests.dll.html')
  end
end

describe XUnitTestRunner, "the command parameters for an xunit runner" do
  it_should_behave_like "xunit paths"
  before :all do
    xunit = XUnitTestRunner.new(@xunitpath)
    xunit.assembly = @test_assembly
    xunit.options @output_option
    
    @command_parameters = xunit.get_command_parameters
  end
    
  it "should not include the path to the command" do
    @command_parameters.should_not include(@xunitpath)
  end
  
  it "should include the list of options" do
    @command_parameters.should include(@output_option)
  end
end

describe XUnitTestRunner, "the command line string for an xunit runner" do
  it_should_behave_like "xunit paths"
  before :all do
    xunit = XUnitTestRunner.new(@xunitpath)
    xunit.assembly = @test_assembly
    xunit.options @output_option
    
    @command_line = xunit.get_command_line
    @command_parameters = xunit.get_command_parameters.join(" ")
  end
    
  it "should start with the path to the command" do
    @command_line.split(" ").first.should == @xunitpath
  end
  
  it "should include the command parameters" do
    @command_line.should include(@command_parameters)
  end
end

describe XUnitTestRunner, "when configured correctly" do
  it_should_behave_like "xunit paths"
  before :all do
    xunit = XUnitTestRunner.new(@xunitpath)
    xunit.assembly = @test_assembly
    xunit.options '/noshadow'
    xunit.extend(FailPatch)
    xunit.log_level = :verbose
    
    xunit.execute
  end
  
  it "should execute" do
    $task_failed.should be_false
  end
end

describe XUnitTestRunner, "when multiple assemblies are passed to xunit runner" do
  it_should_behave_like "xunit paths"
  before :all do
    xunit = XUnitTestRunner.new(@xunitpath)
    xunit.assemblies = @test_assembly, @test_assembly
    xunit.options '/noshadow'
    xunit.extend(FailPatch)
    xunit.log_level = :verbose
    
    xunit.execute
  end
  
  it "should execute" do
    $task_failed.should be_false
  end
end

describe XUnitTestRunner, "when zero assemblies are passed to xunit runner" do
  it_should_behave_like "xunit paths"
  before :all do
    xunit = XUnitTestRunner.new(@xunitpath)    
    xunit.options '/noshadow'
    xunit.extend(FailPatch)
    
    xunit.execute
  end
  
  it "should fail" do
    $task_failed.should be_true
  end
end

describe XUnitTestRunner, "when html_output is specified" do
  it_should_behave_like "xunit paths"
  before :each do
    FileUtils.mkdir @working_dir unless File.exist?(@working_dir)
    xunit = XUnitTestRunner.new(@xunitpath)
    xunit.assembly = @test_assembly    
    xunit.html_output = File.dirname(@html_output)
    xunit.extend(FailPatch)
    
    xunit.execute
  end
  
  it "should execute" do
    $task_failed.should be_false
  end
  
  it "should write output html" do
    sleep(2)
    File.exist?(@html_output).should be_true
  end
  
  after:each do
	FileUtils.rm_r @working_dir if File.exist? @working_dir
  end
end

describe XUnitTestRunner, "when html_output is not a directory" do
  it_should_behave_like "xunit paths"
  before :each do
    FileUtils.mkdir @working_dir unless File.exist?(@working_dir)
    strio = StringIO.new
    xunit = XUnitTestRunner.new(@xunitpath)
    xunit.log_level = :verbose
    xunit.log_device = strio
    xunit.assembly = @test_assembly    
    xunit.html_output = @html_output
    xunit.extend(FailPatch)
    
    xunit.execute
    @log_data = strio.string
  end
  
  it "should fail" do
    $task_failed.should be_true
  end
  
  it "should log a message" do
    @log_data.should include('Directory is required for html_output')    
  end
  
  after:each do
    FileUtils.rm_r @working_dir if File.exist? @working_dir
  end
end

describe XUnitTestRunner, "when providing configuration" do
  let :xunit do
    Albacore.configure do |config|
      config.xunit.command = "configured"
    end
    xunit = XUnitTestRunner.new
  end

  it "should use the configured values" do
    xunit.command.should == "configured"
  end
end
