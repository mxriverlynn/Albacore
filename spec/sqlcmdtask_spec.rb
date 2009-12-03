require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/sqlcmd'
require 'rake/sqlcmdtask'
require 'tasklib_patch'

describe Albacore::SQLCmdTask, "when running" do
	before :all do
		task = Albacore::SQLCmdTask.new(:sqlcmd) do |t|
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:sqlcmd].invoke
	end
	
	it "should yield the sqlcmd api" do
		@yielded_object.kind_of?(SQLCmd).should == true 
	end
end

describe Albacore::SQLCmdTask, "when execution fails" do
	before :all do
		@task = Albacore::SQLCmdTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		@task.task_failed.should be_true
	end
end
