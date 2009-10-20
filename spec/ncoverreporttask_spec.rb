require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ncoverreport'
require 'ncoverreporttask'
require 'tasklib_patch'

describe Albacore::NCoverReportTask, "when running" do
	before :all do
		Albacore::NCoverReportTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the ncover report api" do
		@yielded_object.kind_of?(NCoverReport).should == true 
	end
end

describe Albacore::NCoverReportTask, "when execution fails" do
	before :all do
		@task = Albacore::NCoverReportTask.new(:failingtask)
		@task.extend(TasklibPatch)
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		$task_failed.should == true
	end
end
