require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'rake'
require 'rake/tasklib'
require 'msbuild'
require 'msbuildtask'
require 'tasklib_patch'

describe Albacore::MSBuildTask, "when running" do
	before :all do
		Albacore::MSBuildTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the msbuild api" do
		@yielded_object.kind_of?(MSBuild).should == true 
	end
end

describe Albacore::MSBuildTask, "when execution fails" do
	before :all do
		@msbuildtask = Albacore::MSBuildTask.new(:failingtask)
		@msbuildtask.extend(TasklibPatch)
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		$task_failed.should == true
	end
end
