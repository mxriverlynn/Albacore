require 'spec_helper'
require 'albacore/nunittestrunner'

describe "nunit with paths" do
  before :all do
    @nunitpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NUnit-v2.5', 'nunit-console-x86.exe')
    @test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'nunit', 'assemblies', 'TestSolution.Tests.dll')
    @failing_test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'nunit', 'failing_assemblies', 'TestSolution.FailingTests.dll')
    @output_option = "/out=nunit.results.html"
  end

  describe NUnitTestRunner, "the command parameters for an nunit runner" do
    before :all do
      nunit = NUnitTestRunner.new(@nunitpath)
      nunit.assemblies @test_assembly, @failing_test_assembly
      nunit.options @output_option

      @command_parameters = nunit.get_command_parameters
    end

    it "should not include the path to the command" do
      @command_parameters.should_not include(@nunitpath)
    end

    it "should include the list of assemblies" do
      @command_parameters.should include("\"#{@test_assembly}\" \"#{@failing_test_assembly}\"")
    end

    it "should include the list of options" do
      @command_parameters.should include(@output_option)
    end
  end

  describe NUnitTestRunner, "the command line string for an nunit runner" do

    before :all do
      nunit = NUnitTestRunner.new(@nunitpath)
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


  describe NUnitTestRunner, "when configured correctly" do

    before :all do
      nunit = NUnitTestRunner.new(@nunitpath)
      nunit.extend(FailPatch)
      nunit.assemblies @test_assembly
      nunit.options '/noshadow'

      nunit.execute
    end

    it "should execute" do
      $task_failed.should be_false
    end
  end

  describe NUnitTestRunner, "when using the configuration command and not providing a command in the intializer" do

    before :all do
      Albacore.configure do |config|
        config.nunit.command = "configured command"
      end
      @nunit = NUnitTestRunner.new
    end

    it "should use the configuration command" do
      @nunit.command.should == "configured command"
    end
  end

  describe NUnitTestRunner, "when the command has been set through configuration and providing a command in the intializer" do

    before :all do
      Albacore.configure do |config|
        config.nunit.command = "configured command"
      end
      @nunit = NUnitTestRunner.new("initializer command")
    end

    it "should use the initializer command" do
      @nunit.command.should == "initializer command"
    end
  end
end
describe NUnitTestRunner, "when configuration has been provided" do
  before :all do
    Albacore.configure do |config|
      config.nunit do |nunit|
        nunit.assemblies = ["foo.dll", "bar.dll"]
        nunit.options = ["/noshadow"]
      end
    end

    @nunit = NUnitTestRunner.new
  end

  it "should use the provided configuration" do
    @nunit.assemblies.should == ["foo.dll", "bar.dll"]
    @nunit.options.should == ["/noshadow"]
  end
end
