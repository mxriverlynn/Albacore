require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ncoverconsole'
require 'rake/ncoverconsoletask'
require 'fail_patch'

describe "when running" do
  before :all do
    ncoverconsole :ncoverconsole do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:ncoverconsole].invoke
  end
  
  it "should yield the ncover console api" do
    @yielded_object.kind_of?(NCoverConsole).should == true 
  end
end

describe "when execution fails" do
  before :all do
    ncoverconsole :ncoverconsole_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:ncoverconsole_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end

describe "when task args are used" do
  before :all do
    ncoverconsole :ncoverconsoletask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
  	end
    Rake::Task[:ncoverconsoletask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end
