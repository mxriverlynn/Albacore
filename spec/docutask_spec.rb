require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/docu'
require 'rake/docutask'
require 'fail_patch'
require 'system_patch'
require 'docu_patch'

describe "when running" do
  before :all do
  	docu :docu do |d|
	  d.assemblies 'test.dll'
      d.command_result = true
      @yielded_object = d
  	end
    Rake::Task[:docu].invoke
  end
  
  it "should yield the docu api" do
    @yielded_object.kind_of?(Docu).should be_true
  end
end

describe "when execution fails" do
  before :all do
  	docu :docu_fail do |d|
  	  d.extend(FailPatch)
	  d.assemblies 'test.dll'
      d.command_result = true
	  d.fail
  	end
    Rake::Task[:docu_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should be_true
  end
end

describe "when task args are used" do
  before :all do
    docu :docutask_withargs, [:arg1] do |d, args|
	  d.assemblies 'test.dll'
      d.command_result = true
      @args = args
  	end
    Rake::Task["docutask_withargs"].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end
