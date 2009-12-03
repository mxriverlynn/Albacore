require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'rake/renametask'
require 'tasklib_patch'

describe Albacore::RenameTask, "when running" do
	before :all do
		task = Albacore::RenameTask.new(:rename) do |t|
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:rename].invoke
	end
	
	it "should yield the rename api" do
		@yielded_object.kind_of?(Albacore::RenameTask).should be_true
	end
end

describe Albacore::RenameTask, "when execution fails" do
	before :all do
		@task = Albacore::RenameTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		@task.task_failed.should == true
	end
end
