require 'spec_helper'
require 'albacore/fluentmigratorrunner'

shared_context "fluentmigrator paths" do
  before :all do
    @fluent_migrator_path = File.join(File.dirname(__FILE__), 'support', 'Tools', 'FluentMigrator-0.9', 'Migrate.exe')
    @test_assembly = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'CodeCoverage', 'fluentmigrator', 'assemblies', 'TestSolution.FluentMigrator.dll')
  end
end

describe FluentMigratorRunner, "the command parameters for an migrator runner" do
  include_context "fluentmigrator paths"
 
  before :all do
    @migrator = FluentMigratorRunner.new(@fluent_migrator_path) 
  end

  context "Required params" do
    before :all do
      @command_parameters = @migrator.get_command_parameters
    end

    it "doesn't include command" do
      @command_parameters.should_not include(@fluent_migrator_path)
    end

    it "includes target" do
      @command_parameters.should include("/target")
    end

    it "includes provider" do
      @command_parameters.should include("/provider")
    end

    it "includes connection" do
      @command_parameters.should include("/connection")
    end  
	end

  context "Optional options" do
    before :all do
      @migrator.namespace = 'namespace'
      @migrator.output = true
      @migrator.output_filename = "output.txt"
      @migrator.preview = true
      @migrator.steps = 1
      @migrator.task = 'migrate:up'
      @migrator.version = '001'
      @migrator.verbose = true
      @migrator.script_directory = 'c:\scripts'
      @migrator.profile = 'MyProfile'
      @migrator.timeout = 90
      @command_parameters = @migrator.get_command_parameters
    end

    it "includes ns" do
      @command_parameters.should include('/ns')
    end

    it "includes out" do
      @command_parameters.should include('/out')
    end

    it "includes outfile" do
      @command_parameters.should include('/outfile')
    end 

    it "includes preview" do
      @command_parameters.should include('/preview')
    end

    it "includes steps" do
      @command_parameters.should include('/steps')
    end

    it "includes task" do
      @command_parameters.should include('/task')
    end

    it "includes version" do
      @command_parameters.should include('/version')
    end

    it "includes verbose" do
      @command_parameters.should include('/verbose')
    end 

    it "includes wd" do
      @command_parameters.should include('/wd')
    end

    it "includes profile" do
      @command_parameters.should include('/profile')
    end

    it "includes timeout" do
      @command_parameters.should include('/timeout')
    end
    
    it "excludes help" do
      @command_parameters.should_not include("/?")
    end
  end
  
  context "Help option" do
    it "includes help flag when specifed" do
      @migrator.show_help = true
      command_parameters = @migrator.get_command_parameters
      command_parameters.should == " /?"
    end

    it "excludes help flag when not specifed" do
      @migrator.show_help = false
      command_parameters = @migrator.get_command_parameters
      command_parameters.should_not include "/?"
    end
  end

  context "Boolean options" do
    before :all do
      @migrator.output = false
      @migrator.preview = false
      @migrator.verbose = false
    end

    it "includes /out when output is true" do
      @migrator.output = true
      @migrator.get_command_parameters.should include "/out"
    end
    
    it "excludes /out when output not true" do

      @migrator.output = false
      @migrator.output_filename = nil
      @migrator.get_command_parameters.should_not include "/out"
      @migrator.output = "a"
      @migrator.get_command_parameters.should_not include "/out"
    end

    it "includes /preview when preview is true" do
      @migrator.preview = true
      @migrator.get_command_parameters.should include "/preview"
    end

    it "excludes /preview when preview is not true" do
      @migrator.preview = false
      @migrator.get_command_parameters.should_not include "/preview"

      @migrator.preview = "a"
      @migrator.get_command_parameters.should_not include "/preview"
    end

    it "includes /verbose when verbose is true" do
      @migrator.verbose = true
      @migrator.get_command_parameters.should include "/verbose=true"
    end

    it "excludes /verbose when verbose is not true" do
      @migrator.verbose = false
      @migrator.get_command_parameters.should_not include "/verbose="

      @migrator.verbose = "a"
      @migrator.get_command_parameters.should_not include "/verbose="
    end
  end
end

describe FluentMigratorRunner, "the command line string for an fluentmigrator runner" do
  include_context "fluentmigrator paths"

  before :all do
    migrator = FluentMigratorRunner.new(@fluent_migrator_path)
    migrator.target = @test_assembly
    
    @command_line = migrator.get_command_line
    @command_parameters = migrator.get_command_parameters
  end
    
  it "starts with the path to the command" do
    @command_line.should =~ /^#{@fluent_migrator_path}.*$/
  end
  
  it "includes the command parameters" do
    @command_line.downcase.should include(@command_parameters.downcase)
  end
end

describe FluentMigratorRunner, "when using the configuration command and not providing a command in the intializer" do
  include_context "fluentmigrator paths"

  before :all do
    Albacore.configure do |config|
      config.fluentmigrator.command = "configured command"
    end
    @migrator = FluentMigratorRunner.new
  end

  it "uses the configuration command" do
    @migrator.command.should == "configured command"
  end
end

describe FluentMigratorRunner, "when the command has been set through configuration and providing a command in the intializer" do
  include_context "fluentmigrator paths"

  before :all do
    Albacore.configure do |config|
      config.fluentmigrator.command = "configured command"
    end
    @migrator = FluentMigratorRunner.new("initializer command")
  end

  it "uses the initializer command" do
    @migrator.command.should == "initializer command"
  end
end

describe FluentMigratorRunner, "when configuration has been provided" do
  before :all do
    Albacore.configure do |config|
      config.fluentmigrator do |migrator|
        migrator.target = 'target.dll'
        migrator.provider = 'provider'
        migrator.connection = 'connection'
        migrator.namespace = 'namespace'
        migrator.output = 'output.txt'
        migrator.preview = true
        migrator.steps = 1
        migrator.task = 'migrate:up'
        migrator.version = '001'
        migrator.verbose = true
        migrator.script_directory = 'c:\scripts'
        migrator.profile = 'MyProfile'
        migrator.timeout = 90
      end
    end

    @migrator = FluentMigratorRunner.new
  end

  it "uses the provided configuration" do
    @migrator.target.should == 'target.dll'
    @migrator.provider.should == 'provider'
    @migrator.connection.should == 'connection'
    @migrator.namespace.should == 'namespace'
    @migrator.output.should == 'output.txt'
    @migrator.preview.should == true
    @migrator.steps.should == 1
    @migrator.task.should == 'migrate:up'
    @migrator.version.should == '001'
    @migrator.verbose.should == true
    @migrator.script_directory.should == 'c:\scripts'
    @migrator.profile.should == 'MyProfile'
    @migrator.timeout.should == 90
  end
end
