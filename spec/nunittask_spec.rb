require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/nunittestrunner'
require 'rake/nunittask'
require 'tasklib_patch'

describe Albacore::NUnitTask, "when running" do
	before :all do
		task = Albacore::NUnitTask.new(:nunit) do |t|
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:nunit].invoke
	end
	
	it "should yield the nunit api" do
		@yielded_object.kind_of?(NUnitTestRunner).should be_true
	end
end

describe Albacore::NUnitTask, "when execution fails" do
	before :all do
		@task = Albacore::NUnitTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		@task.task_failed.should == true
	end
end
