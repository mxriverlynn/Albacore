require 'spec_helper'
require 'albacore/albacoretask'
require 'system_patch'

class RunCommandObject
  include Albacore::Task
  include Albacore::RunCommand

  def execute
    result = run_command "Run Command Test Object"
  end
end

describe "when setting the command" do
  before :all do
    @runme = RunCommandObject.new
    @runme.extend SystemPatch

    @runme.command = "test.exe"
    @runme.execute
  end

  it "should execute the specified command, quoted" do
    @runme.system_command.should == "\"test.exe\""
  end
end

describe "when specifying a parameter to a command" do
  before :all do
    @runme = RunCommandObject.new
    @runme.extend SystemPatch
    @runme.command = "test.exe"
    @runme.parameters "param1"
    @runme.execute
  end

  it "should separate the parameters from the command" do
    @runme.system_command.should == "\"test.exe\" param1"
  end
end

describe "when specifying multiple parameters to a command" do
  before :all do
    @runme = RunCommandObject.new
    @runme.extend SystemPatch
    @runme.command = "test.exe"
    @runme.parameters "param1", "param2", "param3"
    @runme.execute
  end

  it "should separate all parameters by a space" do
    @runme.system_command.should == "\"test.exe\" param1 param2 param3"
  end
end

describe "when executing a runcommand object twice" do
  before :all do
    @runmeone = RunCommandObject.new
    @runmetwo = @runmeone
    @runmeone.extend SystemPatch
    @runmeone.command = "test.exe"
    @runmeone.parameters "1", "2", "3"

    @runmeone.execute
    @runmetwo.execute
  end

  it "should only pass the parameters to the command once for the first execution" do
    @runmeone.system_command.should == "\"test.exe\" 1 2 3"
  end

  it "should only pass the parameters to the command once for the second execution" do
    @runmetwo.system_command.should == "\"test.exe\" 1 2 3"
  end
end

describe "when the command exists relative to the project root" do
  before :all do
    @runme = RunCommandObject.new
    @runme.extend SystemPatch

    File.open('test.exe', 'w') {}
    @runme.command = "test.exe"
    @runme.execute
  end

  after :all do
    FileUtils.rm_f('test.exe')
  end

  it "should expand the path" do
    @runme.system_command.should == "\"#{File.expand_path('test.exe')}\""
  end
end
