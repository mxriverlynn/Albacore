require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/assemblyinfo'
require 'rake/assemblyinfotask'
require 'tasklib_patch'

describe Albacore::AssemblyInfoTask, "when running" do
	before :all do
		@task = Albacore::AssemblyInfoTask.new(:task) do |t|
			@yielded_object = t
		end
		@task.extend(TasklibPatch)
		Rake::Task["task"].invoke
	end
	
	it "should yield the assembly info api" do
		@yielded_object.kind_of?(AssemblyInfo).should == true 
	end
end

describe Albacore::AssemblyInfoTask, "when execution fails" do
	before :all do
		@task = Albacore::AssemblyInfoTask.new(:failingtask)
		@task.extend(TasklibPatch)
		@task.fail
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		@task.task_failed.should == true
	end
end
