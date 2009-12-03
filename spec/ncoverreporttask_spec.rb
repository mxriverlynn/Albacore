require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ncoverreport'
require 'rake/ncoverreporttask'
require 'tasklib_patch'

describe Albacore::NCoverReportTask, "when running" do
	before :all do
		task = Albacore::NCoverReportTask.new(:ncoverreport) do |t|
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:ncoverreport].invoke
	end
	
	it "should yield the ncover report api" do
		@yielded_object.kind_of?(NCoverReport).should == true 
	end
end

describe Albacore::NCoverReportTask, "when execution fails" do
	before :all do
		@task = Albacore::NCoverReportTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		@task.task_failed.should == true
	end
end
