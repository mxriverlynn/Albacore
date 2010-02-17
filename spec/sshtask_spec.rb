require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ssh'
require 'rake/sshtask'
require 'fail_patch'

describe "when running" do
  before :all do
    Net::SSH.stub_method(:start, &lambda{}).yields(@sshstub)
  end
  
  before :each do
    ssh :ssh do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:ssh].invoke
  end
  
  it "should yield the ssh api" do
    @yielded_object.kind_of?(Ssh).should == true 
  end
end

describe "when execution fails" do
  before :all do
    Net::SSH.stub_method(:start, &lambda{}).yields(@sshstub)
  end
  
  before :each do
    ssh :ssh_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:ssh_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should be_true
  end
end
