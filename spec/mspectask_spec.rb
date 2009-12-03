require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/mspectestrunner'
require 'rake/mspectask'
require 'tasklib_patch'

describe Albacore::MSpecTask, "when running" do
	before :all do
		task = Albacore::MSpecTask.new(:mspec) do |t|
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:mspec].invoke
	end
	
	it "should yield the mspec api" do
		@yielded_object.kind_of?(MSpecTestRunner).should be_true
	end
end

describe Albacore::MSpecTask, "when execution fails" do
	before :all do
		@task = Albacore::MSpecTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		@task.task_failed.should == true
	end
end
