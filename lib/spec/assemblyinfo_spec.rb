require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'assemblyinfotester'
require 'assemblyinfo'

describe "when generating an assembly info file" do
	
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.version = @tester.version
		asm.title = @tester.title
		asm.description = @tester.description
		
		asm.write(@tester.assemblyinfo_file)
		@filedata = @tester.read_assemblyinfo_file
	end
	
	it "should use the system.reflection namespace" do
		@filedata.should include("using System.Reflection;")
	end
	
	it "should use the system.runtime.interopservices namespace" do
		@filedata.should include("using System.Runtime.InteropServices;")
	end
	
	it "should contain the specified version information" do
		@filedata.should include("[assembly: AssemblyVersion(\"#{@tester.version}\")]")
	end
	
	it "should contain the assembly title" do
		@filedata.should include("[assembly: AssemblyTitle(\"#{@tester.title}\")]")
	end
	
	it "should contain the assembly description" do
		@filedata.should include("[assembly: AssemblyDescription(\"#{@tester.description}\")]")
	end
	
end
