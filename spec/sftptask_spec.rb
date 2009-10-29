require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/sftp'
require 'rake/sftptask'
require 'tasklib_patch'

describe Albacore::SftpTask, "when running" do
	before :all do
		@sftpstub = Net::SFTP::Session.stub_instance(:upload! => nil)
		Net::SFTP.stub_method(:start).yields(@sftpstub)
	end
	
	before :each do
		Albacore::SftpTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the sftp api" do
		@yielded_object.kind_of?(Sftp).should == true 
	end
end

describe Albacore::SftpTask, "when execution fails" do
	before :all do
		@sftpstub = Net::SFTP::Session.stub_instance(:upload! => nil)
		Net::SFTP.stub_method(:start).yields(@sftpstub)
	end
	
	before :each do
		@task = Albacore::SftpTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		$task_failed.should be_true
	end
end
