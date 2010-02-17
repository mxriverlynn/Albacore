require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/plink'
require 'rake/plinktask'
require 'fail_patch'

describe "when running" do
  before :all do
    plink :plink do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:plink].invoke
  end

  it "should yield the command api" do
    @yielded_object.kind_of?(PLink).should == true 
  end
end

describe "when execution fails" do
  before :all do
    plink :plink_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:plink_fail].invoke
  end

  it "should fail the rake task" do
    $task_failed.should be_true
  end
end

describe "when task args are used" do
  before :all do
    plink :plinktask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
    end
    Rake::Task[:plinktask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end