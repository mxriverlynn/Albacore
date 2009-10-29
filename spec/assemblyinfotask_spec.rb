require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/assemblyinfo'
require 'rake/assemblyinfotask'
require 'tasklib_patch'

describe Albacore::AssemblyInfoTask, "when running" do
	before :all do
		Albacore::AssemblyInfoTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the assembly info api" do
		@yielded_object.kind_of?(AssemblyInfo).should == true 
	end
end

describe Albacore::AssemblyInfoTask, "when execution fails" do
	before :all do
		@task = Albacore::AssemblyInfoTask.new(:failingtask)
		@task.extend(TasklibPatch)
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		$task_failed.should == true
	end
end
