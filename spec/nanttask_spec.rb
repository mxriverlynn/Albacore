require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/nant'
require 'rake/nanttask'
require 'fail_patch'

describe "when running" do
  before :all do
    nant :nant do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:nant].invoke
  end
  
  it "should yield the nant api" do
    @yielded_object.kind_of?(NAnt).should == true 
  end
end

describe "when execution fails" do
  before :all do
    nant :nant_failingtask do |t|
      t.extend(FailPatch)
      t.fail
    end    
    Rake::Task[:nant_failingtask].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end

describe "when task args are used" do
  before :all do
    nant :nanttask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
  	end
    Rake::Task[:nanttask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end