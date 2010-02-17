require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/msbuild'
require 'rake/msbuildtask'
require 'fail_patch'

describe Albacore::MSBuildTask, "when running" do
  before :all do
    task = Albacore::MSBuildTask.new(:msbuild) do |t|
      @yielded_object = t
    end
    task.extend(FailPatch)
    Rake::Task[:msbuild].invoke
  end
  
  it "should yield the msbuild api" do
    @yielded_object.kind_of?(MSBuild).should == true 
  end
end

describe Albacore::MSBuildTask, "when execution fails" do
  before :all do
    @task = Albacore::MSBuildTask.new(:failingtask)
    @task.extend(FailPatch)
    @task.fail
    Rake::Task["failingtask"].invoke
  end
  
  it "should fail the rake task" do
    @task.task_failed.should == true
  end
end
