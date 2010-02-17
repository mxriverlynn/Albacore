require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/nant'
require 'rake/nanttask'
require 'fail_patch'

describe Albacore::NAntTask, "when running" do
  before :all do
    task = Albacore::NAntTask.new(:nant) do |t|
      @yielded_object = t
    end
    task.extend(FailPatch)
    Rake::Task[:nant].invoke
  end
  
  it "should yield the nant api" do
    @yielded_object.kind_of?(NAnt).should == true 
  end
end

describe Albacore::NAntTask, "when execution fails" do
  before :all do
    @task = Albacore::NAntTask.new(:nant_failingtask)
    @task.extend(FailPatch)
    @task.fail
    Rake::Task[:nant_failingtask].invoke
  end
  
  it "should fail the rake task" do
    @task.task_failed.should == true
  end
end