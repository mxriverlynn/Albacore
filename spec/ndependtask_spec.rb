require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ndepend'
require 'rake/ndependtask'
require 'fail_patch'

describe "when running" do
  before :all do
    ndepend :ndepend do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:ndepend].invoke
  end

  it "should yield the command api" do
    @yielded_object.kind_of?(NDepend).should == true
  end
end

describe "when execution fails" do
  before :all do
    ndepend :ndepend_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:ndepend_fail].invoke
  end

  it "should fail the rake task" do
    $task_failed.should be_true
  end
end

describe "when task args are used" do
  before :all do
    ndepend :ndependtask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
    end
    Rake::Task[:ndependtask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end