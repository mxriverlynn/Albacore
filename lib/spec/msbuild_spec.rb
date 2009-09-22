require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'msbuild'
require 'msbuildtestdata'
require 'system_patch'

describe MSBuild, "when an msbuild path is not specified" do
	
	before :all do
		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new
	end
	
	it "should default to the .net framework v3.5" do
		@msbuild.path_to_exe.should == @testdata.msbuild_path
	end
end

describe MSBuild, "when an msbuild path is specified" do
	
	before :all do
		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new "Some Path"
	end
	
	it "should use the specified path for the msbuild exe" do
		@msbuild.path_to_exe.should == "Some Path"
	end	
end

describe MSBuild, "when building a visual studio solution" do

	before :all do
		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new
		
		@msbuild.solution = @testdata.solution_path
		@msbuild.build
	end
	
	it "should output the solution's binaries" do
		File.exist?(@testdata.output_path).should == true
	end
end

describe MSBuild, "when building a visual studio solution for a specified configuration" do
	
	before :all do
		@testdata= MSBuildTestData.new("Release")
		@msbuild = MSBuild.new
		
		@msbuild.properties = {:configuration => :release}
		@msbuild.solution = @testdata.solution_path
		@msbuild.build
	end
	
	it "should build with the specified configuration as a property" do
		$system_command.should include("/property:configuration=release")
	end
	
	it "should output the solution's binaries according to the specified configuration" do
		File.exist?(@testdata.output_path).should == true
	end
end

describe MSBuild, "when specifying targets to build" do
	
	before :all do

		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new
		
		@msbuild.targets = [:Clean, :Build]
		@msbuild.solution = @testdata.solution_path
		@msbuild.build
	end

	it "should build the targets" do
		$system_command.should include("/target:Clean;Build")
	end

end
