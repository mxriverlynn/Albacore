require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'sqlcmd'
require 'sqlcmdtask'
require 'tasklib_patch'

describe Rake::SQLCmdTask, "when running" do
	before :all do
		Rake::SQLCmdTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the sqlcmd api" do
		@yielded_object.kind_of?(SQLCmd).should == true 
	end
end

describe Rake::SQLCmdTask, "when execution fails" do
	before :all do
		@task = Rake::SQLCmdTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		$task_failed.should be_true
	end
end
