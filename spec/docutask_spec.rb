require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/docu'
require 'rake/docutask'
require 'tasklib_patch'
require 'docu_patch'

describe Albacore::DocuTask, "when running" do
  before :all do
    task = Albacore::DocuTask.new(:successful_task) do |t|
	  t.assemblies << 'test.dll'
      t.command_result = true
      @yielded_object = t
    end
    
    task.extend(TasklibPatch)
    Rake::Task[:successful_task].invoke
  end
  
  it "should yield the docu api" do
    @yielded_object.kind_of?(Docu).should be_true
  end
end

describe Albacore::DocuTask, "when execution fails" do
  before :all do
    @task = Albacore::DocuTask.new(:failing_task) do |t|
	  t.command_result = false
      t.assemblies << 'test.dll'
    end

    @task.extend(TasklibPatch)

    Rake::Task[:failing_task].invoke
  end
  
  it "should fail the rake task" do
    @task.task_failed.should == true
  end
end