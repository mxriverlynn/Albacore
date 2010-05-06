require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/support/albacore_helper'
require 'system_patch'

class RunCommandObject
  include YAMLConfig
  include RunCommand

  def execute
    @require_valid_command = false
    result = run_command "Run Command Test Object"
  end
end

describe "when running two instances of a command line task" do
  before :all do
    create_task :run_command_task, Proc.new { RunCommandObject.new } do |ex|
      ex.execute
    end

  	run_command_task :one do |x|
      x.extend(SystemPatch)
      x.path_to_command = "set"
      x.parameters "_albacore_test = test_one"
      @one = x
  	end

    run_command_task :two do |x|
      x.extend(SystemPatch)
      x.path_to_command = "set"
      x.parameters "_another_albacore_test = test_two"
      @two = x
    end
    
    Rake::Task[:one].invoke
    Rake::Task[:two].invoke
  end
  
  it "should only pass the parameters specified to the first command" do
    @one.system_command.should == "\"set\" _albacore_test = test_one"
  end
  
  it "should only pass the parameters specified to the second command" do
    @two.system_command.should == "\"set\" _another_albacore_test = test_two"
  end
end


