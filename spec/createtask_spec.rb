require 'spec_helper'
require 'albacore/albacoretask'
require 'fail_patch'
include ::Rake::DSL if defined?(::Rake::DSL)

class SampleObject
  include Albacore::Task

  attr_array :array
  attr_hash :hash

  def get_array
    @array
  end

  def get_hash
    @hash
  end

  def execute
  end
end

class RunCommandObject
  include Albacore::Task
  include Albacore::RunCommand

  def execute
    result = run_command "Run Command Test Object"
  end
end

class ConfigByNameOverride < SampleObject
  attr_accessor :task_name
  def load_config_by_task_name(name)
    @task_name = name
  end
end

describe "when defining a task" do
  before :all do
    Albacore.create_task :sampletask, ConfigByNameOverride

  	sampletask :sample do |x|
  	  @config_obj = x
  	end
    Rake::Task[:sample].invoke
  end
  
  it "should yield the object for configuration" do
    @config_obj.class.should == ConfigByNameOverride
  end
  
  it "should yield the object for execution" do
  	@task_obj.should == @sample_object
  end
  
  it "should call the yaml configuration by task name" do
  	@config_obj.task_name.should == :sample
  end
end

describe "when execution fails" do
  before :all do
    Albacore.create_task :failing_task, SampleObject

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
    Albacore.create_task :task_with_args, SampleObject

    task_with_args :sampletask_withargs, [:arg1] do |t, args|
      @args = args
    end

    Rake::Task[:sampletask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end

describe "when calling a task method without providing a task name" do
  before :all do
    Albacore.create_task :task_without_name, SampleObject

    task_without_name do |t|
      @task_without_name_called = true
    end
    
    Rake::Task[:task_without_name].invoke
  end
  
  it "should create the the task by the task method's name" do
    @task_without_name_called = true
  end
end

describe "when calling a task method without providing a task parameter" do
  before :all do
    Albacore.create_task :task_without_param, SampleObject

    task_without_param do
      @task_without_param_called = true
    end
    
    Rake::Task[:task_without_param].invoke
  end
  
  it "should execute the task with no parameter provided" do
    @task_without_param_called = true
  end
end

describe "when calling a task without a task definition block" do
	
  before :all do
    Albacore.create_task :task_without_body, SampleObject
    
    task_without_body
    
    begin
      Rake::Task[:task_without_body].invoke
      @failed = false
    rescue
      @failed = true
    end
  end		
	
  it "should execute the task" do
  	@failed.should be_false
  end
end

describe "when creating two tasks and executing them" do
  before :all do
    Albacore.create_task :multiple_instance_task, SampleObject

    multiple_instance_task :multi_instance_1 do |mi|
      mi.array 1, 2
      mi.hash = { :a => :b, :c => :d }
      @instance_1 = mi
    end

    multiple_instance_task :multi_instance_2 do |mi|
      mi.array 3, 4
      mi.hash = { :e => :f, :g => :h }
      @instance_2 = mi
    end

    Rake::Task[:multi_instance_1].invoke
    Rake::Task[:multi_instance_2].invoke 
  end

  it "should specify the array values once per task" do
    @instance_1.array.should == [1, 2]
    @instance_2.array.should == [3, 4]
  end

  it "should specify the hash values once per task" do
    @instance_1.hash.should == { :a => :b, :c => :d }
    @instance_2.hash.should == { :e => :f, :g => :h }
  end

  it "should create two separate instances of the task object" do
    @instance_1.object_id.should_not == @instance_2.object_id
  end
end

describe "when running two instances of a command line task" do
  before :all do
    Albacore.create_task :run_command_task, RunCommandObject do |ex|
      ex.execute
    end

  	run_command_task :one do |x|
      x.extend(SystemPatch)
      x.command = "set"
      x.parameters "_albacore_test = test_one"
      @one = x
  	end

    run_command_task :two do |x|
      x.extend(SystemPatch)
      x.command = "set"
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

describe "when adding prerequisites through the rake api" do
  let :obj do
    Albacore.create_task :dependency_task, Object

    require 'ostruct'
    obj = OpenStruct.new

    task :first_task
    task :second_task do
      obj.dependency_called = true
    end

    firsttask = Rake::Task[:first_task]
    firsttask.enhance [:second_task]
    firsttask.invoke

    obj
  end

  it "should call the dependent tasks" do
    obj.dependency_called.should be_true
  end
end
