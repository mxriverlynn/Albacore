require 'lib/msbuild'

describe MSBuild, "when initializing without an msbuild path specified" do
	
	before :each do
		@msbuild = MSBuild.new
	end
	
	it "should default to the .net framework v3.5" do
		@msbuild.path_to_exe.should == "\"C:\\Windows/Microsoft.NET/Framework/v3.5/msbuild.exe\""
	end
end