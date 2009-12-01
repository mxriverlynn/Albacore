require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/xunittestrunner'
<<<<<<< HEAD:spec/xunittestrunnertask_spec.rb
require 'rake/xunittestrunnertask'
require 'tasklib_patch'

describe Albacore::XUnitTestRunnerTask, "when running" do
	before :all do
		task = Albacore::XUnitTestRunnerTask.new() do |t|
=======
require 'rake/xunittask'
require 'tasklib_patch'

describe Albacore::XUnitTask, "when running" do
	before :all do
		task = Albacore::XUnitTask.new() do |t|
>>>>>>> 6cc51b536b718607357ac9970c8f08d9caffbeb2:spec/xunittask_spec.rb
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:xunit].invoke
	end

	it "should yield the xunit api" do
		@yielded_object.kind_of?(XUnitTestRunner).should be_true
	end
end

<<<<<<< HEAD:spec/xunittestrunnertask_spec.rb
describe Albacore::XUnitTestRunnerTask, "when execution fails" do
	before :all do
		@task = Albacore::XUnitTestRunnerTask.new(:failingtask)
=======
describe Albacore::XUnitTask, "when execution fails" do
	before :all do
		@task = Albacore::XUnitTask.new(:failingtask)
>>>>>>> 6cc51b536b718607357ac9970c8f08d9caffbeb2:spec/xunittask_spec.rb
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end

	it "should fail the rake task" do
		@task.task_failed.should == true
	end
end
