require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/xunittestrunner'
require 'rake/xunittask'
require 'fail_patch'

describe "when running" do
  before :all do
    xunit :xunit do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:xunit].invoke
  end

  it "should yield the xunit api" do
    @yielded_object.kind_of?(XUnitTestRunner).should be_true
  end
end

describe "when execution fails" do
  before :all do
    xunit :xunit_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:xunit_fail].invoke
  end

  it "should fail the rake task" do
    $task_failed.should == true
  end
end
