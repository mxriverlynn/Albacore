require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/expandtemplates'
require 'rake/expandtemplatestask'
require 'fail_patch'

describe "when running" do
  before :each do
    expandtemplates :expandtemplates do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:expandtemplates].invoke
  end
  
  it "should yield the expand template api" do
    @yielded_object.kind_of?(ExpandTemplates).should == true 
  end
end

describe "when execution fails" do
  before :each do
  	expandtemplates :expand_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:expand_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should be_true
  end
end

describe "when task args are used" do
  before :all do
    expandtemplates :expandtask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
  	end
    Rake::Task[:expandtask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end
