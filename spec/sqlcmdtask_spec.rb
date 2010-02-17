require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/sqlcmd'
require 'rake/sqlcmdtask'
require 'fail_patch'

describe "when running" do
  before :all do
    sqlcmd :sqlcmd do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:sqlcmd].invoke
  end
  
  it "should yield the sqlcmd api" do
    @yielded_object.kind_of?(SQLCmd).should == true 
  end
end

describe "when execution fails" do
  before :all do
    sqlcmd :sqlcmd_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:sqlcmd_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should be_true
  end
end
