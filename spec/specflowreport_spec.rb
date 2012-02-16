require 'spec_helper'
require 'albacore/specflowreport'
require 'albacore/nunittestrunner'

describe "specflow paths" do
  before :all do
    @specflowpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'SpecFlow', 'specflow.exe')
    @test_project = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'TestSolution', 'TestSolution.SpecFlow', 'TestSolution.SpecFlow.csproj')
    @nunit_test_restuls = "/xmlTestResult:TestResult.xml"
    @output_option = "/out:specs.html"
  end

  describe SpecFlowReport, "when running without specifying command path" do  

    before :all do
      @spec = SpecFlowReport.new()
      @spec.projects @test_project
    end

    it "should try to run in same folder" do
      @spec.command.should eql('specflow.exe')
    end
  end

  describe SpecFlowReport, "When passing a command" do

    before :all do
      @spec = SpecFlowReport.new("/path_to_command/")
      @spec.projects @test_project
    end

    it "should not include specflow.exe" do
      @spec.command.should eql('/path_to_command/')
    end
  end

  describe SpecFlowReport, "When passing some options" do
    before :all do
      spec =  SpecFlowReport.new()
      spec.options @output_option
      spec.projects @test_project
      @command_line = spec.get_command_line
    end

    it "should include the options in the command line" do
      @command_line.should include(@output_option)
    end
  end

  describe SpecFlowReport, "When no options are passed" do

    before :all do
      spec = SpecFlowReport.new()
      spec.projects @test_project
      @command_line = spec.get_command_line
    end

    it "should include sensible defaults" do
      @command_line.should include("/xmlTestResult:TestResult.xml /out:specs.html")
    end
  end

  describe SpecFlowReport, "When a report is specified" do
    before :all do
      @spec = SpecFlowReport.new()
      @spec.report = 'assigned report'
      @spec.projects @test_project
    end

    it "should include the specified report in the command line" do
      @spec.get_command_line.should include("assigned report")
    end
  end

  describe SpecFlowReport, "When no report is specified" do
    before :all do
      @spec = SpecFlowReport.new()
      @spec.projects @test_project
    end

    it "should include the nunit report in the command line" do
      @spec.get_command_line.should include("nunitexecutionreport")
    end
  end

  describe SpecFlowReport, "when configured correctly" do

    before :all do
      nunitpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NUnit-v2.5', 'nunit-console-x86.exe')
      test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'SpecFlow', 'TestSolution.SpecFlow.dll')

      nunit = NUnitTestRunner.new(nunitpath)
      nunit.extend(FailPatch)
      nunit.assemblies test_assembly
      nunit.options '/noshadow /out=TestResult.xml'
      nunit.execute

      spec = SpecFlowReport.new(@specflowpath)
      spec.extend(FailPatch)
      spec.projects @test_project

      spec.execute
    end

    it "should execute" do
      $task_failed.should be_false
    end
  end

  describe SpecFlowReport, "When not passing a project" do

    before :all do
      @spec = SpecFlowReport.new()
      @spec.extend(FailPatch)
      @spec.execute
      $task_failed.should be_true
    end

    it "should fail" do
      $task_failed.should be_true
    end
  end
end





describe SpecFlowReport, "when providing configuration" do
  let :specflow do
    Albacore.configure do |config|
      config.specflowreport.command = "configured"
      config.specflowreport.report = "configured report"
    end
    specflow = SpecFlowReport.new
  end

  it "should use the configured values" do
    specflow.command.should == "configured"
    specflow.report.should == "configured report"
  end
end

