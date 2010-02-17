require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/mspectestrunner'
require 'rake/mspectask'
require 'fail_patch'

describe "when running" do
  before :all do
    mspec :mspec do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:mspec].invoke
  end
  
  it "should yield the mspec api" do
    @yielded_object.kind_of?(MSpecTestRunner).should be_true
  end
end

describe "when execution fails" do
  before :all do
    mspec :mspec_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:mspec_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end

describe "when task args are used" do
  before :all do
    mspec :mspectask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
  	end
    Rake::Task[:mspectask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end
