require 'lib/msbuild'

describe MSBuild, "when initializing without an msbuild path specified" do
	
	before :all do
		@msbuild = MSBuild.new
	end
	
	it "should default to the .net framework v3.5" do
		@msbuild.path_to_exe.should == "C:\\Windows/Microsoft.NET/Framework/v3.5/MSBuild.exe"
	end
end

describe MSBuild, "when building a visual studio solution" do

	before :all do
		@solution = File.join(File.dirname(__FILE__), 'support', 'TestSolution', 'TestSolution.sln')
		@output = "D:\\Dev\\Derick-GitHub\\MSBuildTask\\lib\\spec\\support\\TestSolution\\TestSolution\\bin\\Debug\\TestSolution.dll"
		File.delete @output if File.exist? @output
		@msbuild = MSBuild.new
		@msbuild.build @solution
	end
	
	it "should output the solution's binaries" do
		File.exist?(@output).should == true
	end
end

describe MSBuild, "when building a visual studio solution for a specified configuration" do
	
	before :all do
		@solution = File.join(File.dirname(__FILE__), 'support', 'TestSolution', 'TestSolution.sln')
		@output = "D:\\Dev\\Derick-GitHub\\MSBuildTask\\lib\\spec\\support\\TestSolution\\TestSolution\\bin\\Release\\TestSolution.dll"
		File.delete @output if File.exist? @output
		@msbuild = MSBuild.new
		@msbuild.build @solution, {:configuration => :release}
	end
	
	it "should output the solution's binaries according to the specified configuration" do
		File.exist?(@output).should == true
	end
end