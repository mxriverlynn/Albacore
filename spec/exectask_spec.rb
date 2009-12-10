require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/exec'
require 'rake/exectask'
require 'tasklib_patch'

describe Albacore::ExecTask, "when running" do
  before :all do
    task = Albacore::ExecTask.new(:exec) do |t|
      @yielded_object = t
    end
    task.extend(TasklibPatch)
    Rake::Task[:exec].invoke
  end
  
  it "should yield the exec api" do
    @yielded_object.kind_of?(Exec).should == true 
  end
end

describe Albacore::ExecTask, "when execution fails" do
  before :all do
    @task = Albacore::ExecTask.new(:failingtask)
    @task.extend(TasklibPatch)
    @task.fail
    Rake::Task["failingtask"].invoke
  end
  
  it "should fail the rake task" do
    @task.task_failed.should be_true
  end
end
