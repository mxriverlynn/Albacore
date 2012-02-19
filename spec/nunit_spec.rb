require 'spec_helper'
require 'patches/fail_patch'
require 'albacore/nunitrunner'

shared_context("nunit task") {
  before(:all) {
    @nunitpath = File.join 'support', 'Tools', 'NUnit-2.5.10', 'nunit-console.exe'
    @nunit = NUnitRunner.new @nunitpath
    @nunit.log_level = :verbose
  }
  subject { @nunit }
}

describe "nunit with paths" do

  include_context "nunit task"

  before :all do
    @test_assembly = File.join('support', 'CodeCoverage', 'nunit', 'assemblies', 'TestSolution.Tests.dll')
    @failing_test_assembly = File.join('support', 'CodeCoverage', 'nunit', 'failing_assemblies', 'TestSolution.FailingTests.dll')
    @output_option = "/out=nunit.results.html"
  end

  describe NUnitRunner, "with the command parameters for an nunit runner" do
    before :all do
      @nunit.assemblies @test_assembly, @failing_test_assembly
      @nunit.options @output_option
    end
    
    subject { @nunit.get_command_parameters }

    it "should not include the path to the command" do
      subject.should_not include(@nunitpath)
    end

    it "should include the list of assemblies" do
      subject.should include("\"#{@test_assembly}\" \"#{@failing_test_assembly}\"")
    end

    it "should include the list of options" do
      subject.should include(@output_option)
    end
  end

  describe NUnitRunner, "the command line string for an nunit runner" do

    before :all do
      nunit = NUnitRunner.new(@nunitpath)
      nunit.assemblies @test_assembly
      nunit.options @output_option

      @command_line = nunit.get_command_line
      @command_parameters = nunit.get_command_parameters.join(" ")
    end

    it "should start with the path to the command" do
      @command_line.split(" ").first.should == @nunitpath
    end

    it "should include the command parameters" do
      @command_line.should include(@command_parameters)
    end
  end


  describe NUnitRunner, "when configured correctly" do
    before(:all) {
      subject.extend(FailPatch)
      subject.assemblies @test_assembly
      subject.options '/noshadow'
      subject.execute
    }

    it "should execute" do
      $task_failed.should be_false
    end
  end

  describe NUnitRunner, "when using the configuration command and not providing a command in the intializer" do

    before :all do
      Albacore.configure do |config|
        config.nunit.command = "configured command"
      end
      @nunit = NUnitRunner.new
    end

    it "should use the configuration command" do
      @nunit.command.should == "configured command"
    end
  end

  describe NUnitRunner, "when the command has been set through configuration and providing a command in the intializer" do

    before :all do
      Albacore.configure do |config|
        config.nunit.command = "configured command"
      end
      @nunit = NUnitRunner.new("initializer command")
    end

    it "should use the initializer command" do
      @nunit.command.should == "initializer command"
    end
  end
end

describe NUnitRunner, "when configuration has been provided" do
  before :all do
    Albacore.configure do |config|
      config.nunit do |nunit|
        nunit.assemblies = ["foo.dll", "bar.dll"]
        nunit.options = ["/noshadow"]
      end
    end

    @nunit = NUnitRunner.new
  end

  it "should use the provided configuration" do
    @nunit.assemblies.should == ["foo.dll", "bar.dll"]
    @nunit.options.should == ["/noshadow"]
  end
end
