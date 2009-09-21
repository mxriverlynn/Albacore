require 'lib/msbuild'
require 'lib/rake/msbuildtask'

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
