require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/renamer'
require 'rake/renametask'
require 'fail_patch'

describe "when running" do
  before :all do
    rename :rename do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:rename].invoke
  end
  
  it "should yield the rename api" do
    @yielded_object.kind_of?(Renamer).should be_true
  end
end

describe "when execution fails" do
  before :all do
    rename :rename_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:rename_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end
