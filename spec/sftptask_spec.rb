require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/sftp'
require 'rake/sftptask'
require 'fail_patch'

describe "when running" do
  before :all do
    @sftpstub = Net::SFTP::Session.stub_instance(:upload! => nil)
    Net::SFTP.stub_method(:start).yields(@sftpstub)
  end
  
  before :each do
    sftp :sftp do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:sftp].invoke
  end
  
  it "should yield the sftp api" do
    @yielded_object.kind_of?(Sftp).should == true 
  end
end

describe "when execution fails" do
  before :all do
    @sftpstub = Net::SFTP::Session.stub_instance(:upload! => nil)
    Net::SFTP.stub_method(:start).yields(@sftpstub)
  end
  
  before :each do
    sftp :sftp_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:sftp_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should be_true
  end
end
