require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/support/albacore_helper'
require 'fail_patch'
require 'yamlconfig_patch'

class SampleObject < OpenStruct
  include Failure
  include YAMLConfig
end

create_task :sampletask, SampleObject.new do |obj|
  obj.task_created = true
  $create_task_obj = obj
end

describe "when defining a task" do
  before :all do
  	sampletask :sample do |x|
      x.extend(FailPatch)
      x.configured = true
  	  @yielded_object = x
  	end
    Rake::Task[:sample].invoke
  end
  
  it "should yield the object for configuration" do
    @yielded_object.configured.should be_true
  end
  
  it "should yield the object for execution" do
  	$create_task_obj.task_created.should be_true
  end
  
  it "should call the yaml configuration by task name" do
  	$create_task_obj.yamlconfig_name.should == "sample"
  end
end

describe "when execution fails" do
  before :all do
  	sampletask :sample_fail do |x|
  	  x.extend(FailPatch)
  	  x.fail
  	end
    Rake::Task[:sample_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end

describe "when task args are used" do
  before :all do
    sampletask :sampletask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
    end
    Rake::Task[:sampletask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end