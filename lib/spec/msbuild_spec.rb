require 'lib/msbuild'
require 'lib/spec/model/msbuildtestdata'

describe MSBuild, "when initializing without an msbuild path specified" do
	
	before :all do
		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new
	end
	
	it "should default to the .net framework v3.5" do
		@msbuild.path_to_exe.should == @testdata.msbuild_path
	end
end

describe MSBuild, "when building a visual studio solution" do

	before :all do
		@testdata= MSBuildTestData.new
		@msbuild = MSBuild.new
		
		@msbuild.build @testdata.solution_path
	end
	
	it "should output the solution's binaries" do
		File.exist?(@testdata.output_path).should == true
	end
end

describe MSBuild, "when building a visual studio solution for a specified configuration" do
	
	before :all do
		@testdata= MSBuildTestData.new("Release")
		@msbuild = MSBuild.new
		
		@msbuild.build @testdata.solution_path, {:configuration => :release}
	end
	
	it "should output the solution's binaries according to the specified configuration" do
		File.exist?(@testdata.output_path).should == true
	end
end