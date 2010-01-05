require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/nant'
require 'rake/nanttask'

describe Albacore::NAntTask, "when running" do
  before :all do
    task = Albacore::NAntTask.new() do |t|
      @yielded_object = t
    end
    Rake::Task[:nant].invoke
  end
  
  it "should yield the nant api" do
    @yielded_object.kind_of?(NAnt).should == true 
  end
end

describe Albacore::NAntTask, "when execution fails" do
  before :all do
    @task = Albacore::NAntTask.new(:failingtask)
    @task.extend(TasklibPatch)
    @task.fail
    Rake::Task["failingtask"].invoke
  end
  
  it "should fail the rake task" do
    @task.task_failed.should == true
  end
end