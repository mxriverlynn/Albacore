require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/expandtemplates'
require 'rake/expandtemplatestask'
require 'tasklib_patch'

describe Albacore::ExpandTemplatesTask, "when running" do
	before :each do
		task = Albacore::ExpandTemplatesTask.new(:expandtemplates) do |t|
			@yielded_object = t
		end
		task.extend(TasklibPatch)
		Rake::Task[:expandtemplates].invoke
	end
	
	it "should yield the expand template api" do
		@yielded_object.kind_of?(ExpandTemplates).should == true 
	end
end

describe Albacore::ExpandTemplatesTask, "when execution fails" do
	before :each do
		@task = Albacore::ExpandTemplatesTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		@task.task_failed.should be_true
	end
end
