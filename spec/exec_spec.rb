require 'spec_helper'
require 'albacore/exec'

describe Exec, "when executing a command with parameters" do
  before :all do
    @nunit = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NUnit-v2.5', 'nunit-console-x86.exe')

    @cmd = Exec.new
    @cmd.log_level = :verbose
    @cmd.extend(SystemPatch)
    @cmd.extend(FailPatch)
    @cmd.command = @nunit
    @cmd.parameters "--help"
    @cmd.execute
  end
  
  it "should run the command with the parameters" do
    @cmd.system_command.should include("\"#{File.expand_path(@nunit)}\" --help")
  end
  
  it "should specify the parameters only once" do
  	@cmd.system_command.scan(/--help/).length.should be(1)
  end
  
  it "should not fail" do
    $task_failed.should be_false
  end
end

describe Exec, "when providing configuration" do 
  let :exec do
    Albacore.configure do |config|
      config.exec do |exe|
        exe.command = "foo.exe"
        exe.parameters = ["bar", "baz"]
      end
    end
    exec = Exec.new
  end

  it "should use the configuration" do
    exec.command.should == "foo.exe"
    exec.parameters.should == ["bar", "baz"]
  end
end
