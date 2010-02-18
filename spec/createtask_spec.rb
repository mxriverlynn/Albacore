require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/support/albacore_helper'
require 'fail_patch'

class SampleObject
  include Failure
  include YAMLConfig
end

describe "when defining a task" do
  before :all do
    @sample_object = SampleObject.stub_instance()
    @sample_object.stub_method(:load_config_by_task_name){ |name|
    	@task_name = name
    }
    create_task :sampletask, @sample_object do |obj|
      @task_obj = obj
    end

  	sampletask :sample do |x|
      x.extend(FailPatch)
  	  @config_obj = x
  	end
    Rake::Task[:sample].invoke
  end
  
  it "should yield the object for configuration" do
    @config_obj.should == @sample_object
  end
  
  it "should yield the object for execution" do
  	@task_obj.should == @sample_object
  end
  
  it "should call the yaml configuration by task name" do
  	@task_name.should == "sample"
  end
end

describe "when execution fails" do
  before :all do
    create_task :failing_task, SampleObject.new

  	failing_task :sample_fail do |x|
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
    create_task :task_with_args, SampleObject.new

    task_with_args :sampletask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
    end
    Rake::Task[:sampletask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end