require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/specflowrunner'

shared_examples_for "specflow paths" do
  before :all do
    @specflowpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'SpecFlow', 'specflow.exe')
    @test_project = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'TestSolution', 'TestSolution.SpecFlow', 'TestSolution.SpecFlow.csproj')
    @nunit_test_restuls = "/xmlTestResult:TestResult.xml"
    @output_option = "/out:specs.html"
  end
end

describe SpecFlowRunner, "when running without specifying command path" do  
  it_should_behave_like "specflow paths"
	
  before :all do
    @spec = SpecFlowRunner.new()
    @spec.projects @test_project
  end

  it "should try to run in same folder" do
    @spec.path_to_command.should eql('')
  end
end

describe SpecFlowRunner, "When not passing a project" do
	
	before :all do
		@spec = SpecFlowRunner.new()
	 	@spec.extend(FailPatch)
    	@spec.execute
    	$task_failed.should be_true
	end
	
	it "should fail" do
		$task_failed.should be_true
	end
end

describe SpecFlowRunner, "When passing a command" do
	it_should_behave_like "specflow paths"
	
	before :all do
		@spec = SpecFlowRunner.new("/path_to_command/")
		@spec.projects @test_project
	end
	
	it "should not include specflow.exe" do
		@spec.path_to_command.should eql('/path_to_command/')
	end
end

describe SpecFlowRunner, "When passing some options" do
	it_should_behave_like "specflow paths"
	before :all do
		spec =  SpecFlowRunner.new()
		spec.options @output_option
		spec.projects @test_project
		@command_line = spec.get_command_line
	end
	
	it "should include the options in the command line" do
		@command_line.should include(@output_option)
	end
end

describe SpecFlowRunner, "When no options are passed" do
	it_should_behave_like "specflow paths"
	
	before :all do
		spec = SpecFlowRunner.new()
		spec.projects @test_project
		@command_line = spec.get_command_line
	end
	
	it "should include sensible defaults" do
		@command_line.should include("/xmlTestResult:TestResult.xml /out:specs.html")
	end
end