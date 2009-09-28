require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'msbuild'
require 'msbuildtestdata'
require 'system_patch'

describe MSBuild, "when building a solution with verbose logging turned on" do	
	before :all do
		@testdata = MSBuildTestData.new
		msbuild = @testdata.msbuild
		strio = StringIO.new
		msbuild.log_device = strio
		msbuild.log_level = :verbose
		
		msbuild.solution = @testdata.solution_path
		msbuild.build
		
		@log_data = strio.string
	end

	it "should log the msbuild command line being called" do
		@log_data.should include("Executing MSBuild: \"C:\\Windows/Microsoft.NET/Framework/v3.5/MSBuild.exe\"")
	end
end

describe MSBuild, "when an msbuild path is not specified" do
	
	before :all do
		@testdata = MSBuildTestData.new
		@msbuild = @testdata.msbuild
	end
	
	it "should default to the .net framework v3.5" do
		@msbuild.path_to_exe.should == @testdata.msbuild_path
	end
end

describe MSBuild, "when an msbuild path is specified" do
	
	before :all do
		@testdata = MSBuildTestData.new
		@msbuild = @testdata.msbuild "Some Path"
	end
	
	it "should use the specified path for the msbuild exe" do
		@msbuild.path_to_exe.should == "Some Path"
	end	
end

describe MSBuild, "when building a visual studio solution" do

	before :all do
		@testdata = MSBuildTestData.new
		@msbuild = @testdata.msbuild
		
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
		@msbuild = @testdata.msbuild
		
		@msbuild.properties :configuration => :release
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
		@msbuild = @testdata.msbuild
		
		@msbuild.targets [:Clean, :Build]
		@msbuild.solution = @testdata.solution_path
		@msbuild.build
	end

	it "should build the targets" do
		$system_command.should include("/target:Clean;Build")
	end

end
