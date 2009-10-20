require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ncoverreport'
require 'ncoverreporttask'
require 'tasklib_patch'

describe Rake::NCoverReportTask, "when running" do
	before :all do
		Rake::NCoverReportTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the ncover report api" do
		@yielded_object.kind_of?(NCoverReport).should == true 
	end
end

describe Rake::NCoverReportTask, "when execution fails" do
	before :all do
		@task = Rake::NCoverReportTask.new(:failingtask)
		@task.extend(TasklibPatch)
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		$task_failed.should == true
	end
end
