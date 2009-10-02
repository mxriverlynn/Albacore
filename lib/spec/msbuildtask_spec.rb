require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'rake'
require 'rake/tasklib'
require 'msbuild'
require 'msbuildtask'
require 'tasklib_patch'

describe Rake::MSBuildTask, "when running" do
	before :all do
		Rake::MSBuildTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the msbuild api" do
		@yielded_object.kind_of?(MSBuild).should == true 
	end
end

describe Rake::MSBuildTask, "when specifying the msbuild path" do
	before :all do
		@msbuildtask = Rake::MSBuildTask.new(:name, "Path To Exe") do |t|
			@msbuild = t
		end
	end
	
	it "should use the specified path for the msbuild exe" do
		@msbuild.path_to_exe.should == "Path To Exe"
	end
end

describe Rake::MSBuildTask, "when execution fails" do
	before :all do
		@msbuildtask = Rake::MSBuildTask.new(:failingtask)
		@msbuildtask.extend(TasklibPatch)
		Rake::Task["failingtask"].invoke
	end
	
	it "should fail the rake task" do
		$task_failed.should == true
	end
end
