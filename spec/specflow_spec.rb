require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/specflowrunner'

shared_examples_for "specflow paths" do
  before :all do
    @specflowpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'SpecFlow', 'specflow.exe')
    @test_solution = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'TestSolution', 'TestSolution.SpecFlow', 'TestSolution.SpecFlow.csproj')
    @nunit_test_restuls = "/xmlTestResult:TestResult.xml"
    @output_option = "/out:specs.html"
  end
end

describe SpecFlowRunner, "when running without specifying command path" do  
  before :all do
    @spec = SpecFlowRunner.new()
  end

  it "should try to run in same folder" do
    @spec.path_to_command.should eql('specflow.exe')
  end
end