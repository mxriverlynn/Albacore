require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/command'
require 'rake/commandtask'
require 'tasklib_patch'

describe Albacore::CommandTask, "when running" do
	before :all do
		task = Albacore::CommandTask.new(:command) do |t|
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:command].invoke
	end
	
	it "should yield the command api" do
		@yielded_object.kind_of?(Command).should == true 
	end
end

describe Albacore::CommandTask, "when execution fails" do
	before :all do
		@task = Albacore::CommandTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		@task.task_failed.should be_true
	end
end
