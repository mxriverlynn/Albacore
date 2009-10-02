require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'assemblyinfo'
require 'assemblyinfotask'
require 'tasklib_patch'

describe Rake::AssemblyInfoTask, "when running" do
	before :all do
		Rake::AssemblyInfoTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the assembly info api" do
		@yielded_object.kind_of?(AssemblyInfo).should == true 
	end
end

describe Rake::AssemblyInfoTask, "when execution fails" do
	before :all do
		@task = Rake::AssemblyInfoTask.new(:failingtask)
		@task.extend(TasklibPatch)
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		$task_failed.should == true
	end
end
