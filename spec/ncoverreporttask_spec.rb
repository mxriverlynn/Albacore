require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ncoverreport'
require 'rake/ncoverreporttask'
require 'fail_patch'

describe "when running" do
  before :all do
    ncoverreport :ncoverreport do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:ncoverreport].invoke
  end
  
  it "should yield the ncover report api" do
    @yielded_object.kind_of?(NCoverReport).should == true 
  end
end

describe "when execution fails" do
  before :all do
    ncoverreport :ncoverreport_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:ncoverreport_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end

describe "when task args are used" do
  before :all do
    ncoverreport :ncoverreporttask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
  	end
    Rake::Task[:ncoverreporttask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end