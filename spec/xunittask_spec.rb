require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/xunittestrunner'
require 'rake/xunittask'
require 'tasklib_patch'

describe Albacore::XUnitTask, "when running" do
	before :all do
		task = Albacore::XUnitTask.new(:xunit) do |t|
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:xunit].invoke
	end

	it "should yield the xunit api" do
		@yielded_object.kind_of?(XUnitTestRunner).should be_true
	end
end

describe Albacore::XUnitTask, "when execution fails" do
	before :all do
		@task = Albacore::XUnitTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end

	it "should fail the rake task" do
		@task.task_failed.should == true
	end
end
