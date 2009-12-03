require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ssh'
require 'rake/sshtask'
require 'tasklib_patch'

describe Albacore::SshTask, "when running" do
	before :all do
		Net::SSH.stub_method(:start, &lambda{}).yields(@sshstub)
	end
	
	before :each do
		task = Albacore::SshTask.new(:ssh) do |t|
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:ssh].invoke
	end
	
	it "should yield the ssh api" do
		@yielded_object.kind_of?(Ssh).should == true 
	end
end

describe Albacore::SshTask, "when execution fails" do
	before :all do
		Net::SSH.stub_method(:start, &lambda{}).yields(@sshstub)
	end
	
	before :each do
		@task = Albacore::SshTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		@task.task_failed.should be_true
	end
end
