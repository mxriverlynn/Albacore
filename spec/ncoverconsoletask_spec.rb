require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ncoverconsole'
require 'rake/ncoverconsoletask'
require 'fail_patch'

describe Albacore::NCoverConsoleTask, "when running" do
  before :all do
    task = Albacore::NCoverConsoleTask.new(:ncoverconsole) do |t|
      @yielded_object = t
    end
    task.extend(FailPatch)
    Rake::Task[:ncoverconsole].invoke
  end
  
  it "should yield the ncover console api" do
    @yielded_object.kind_of?(NCoverConsole).should == true 
  end
end

describe Albacore::NCoverConsoleTask, "when execution fails" do
  before :all do
    @task = Albacore::NCoverConsoleTask.new(:failingtask)
    @task.extend(FailPatch)
    @task.fail
    Rake::Task["failingtask"].invoke
  end
  
  it "should fail the rake task" do
    @task.task_failed.should == true
  end
end
