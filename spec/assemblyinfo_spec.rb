require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'assemblyinfotester'
require 'albacore/assemblyinfo'

describe AssemblyInfo, "when generating an assembly info file" do
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		strio = StringIO.new
		asm.log_device = strio
		
		@tester.build_and_read_assemblyinfo_file asm
		
		@log_data = strio.string
	end
	
	it "should log the name of the output file" do
		@log_data.should include(@tester.assemblyinfo_file)
	end
end

describe AssemblyInfo, "when generating an assembly info file in verbose mode" do
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		strio = StringIO.new
		asm.log_device = strio
		asm.log_level = :verbose
		
		asm.version = @tester.version
		
		@tester.build_and_read_assemblyinfo_file asm
		@log_data = strio.string
	end
	
	it "should log the name of the output file" do
		@log_data.should include(@tester.assemblyinfo_file)
	end
	
	it "should log the supplied attribute information" do
		@log_data.should include("[assembly: AssemblyVersion(\"#{@tester.version}\")]")
	end
end

describe AssemblyInfo, "when generating an assembly info file without an output file specified" do
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		strio = StringIO.new
		asm.log_device = strio
		
		asm.write

		@log_data = strio.string
	end
	
	it "should log an error message saying the output file is required" do
		@log_data.should include("output_file cannot be nil")
	end
end

describe AssemblyInfo, "when providing custom namespaces" do 
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new		
		
		asm.namespaces ['My.Name.Space', 'Another.Namespace.GoesHere']

		@filedata = @tester.build_and_read_assemblyinfo_file asm
	end
	
	it "should write the namespaces into the using statements" do
		@filedata.should include("using My.Name.Space;")
		@filedata.should include("using Another.Namespace.GoesHere;")
	end
end

describe AssemblyInfo, "when providing custom attributes" do	
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.custom_attributes :CustomAttribute => "custom attribute data", :AnotherAttribute => "more data here"

		@filedata = @tester.build_and_read_assemblyinfo_file asm
	end
	
	it "should write the custom attributes to the assembly info file" do
		@filedata.should include("[assembly: CustomAttribute(\"custom attribute data\")]")
		@filedata.should include("[assembly: AnotherAttribute(\"more data here\")]")
	end
end

describe AssemblyInfo, "when specifying a custom attribute with no data" do
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.custom_attributes :NoArgsAttribute => nil

		@filedata = @tester.build_and_read_assemblyinfo_file asm
	end
	
	it "should write the attribute with an empty argument list" do
		@filedata.should include("[assembly: NoArgsAttribute()]")
	end
end

describe AssemblyInfo, "when specifying an attribute with non-string data" do
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.custom_attributes :NonStringAttribute => true

		@filedata = @tester.build_and_read_assemblyinfo_file asm
	end
	
	it "should write the attribute data without quotes" do
		@filedata.should include("[assembly: NonStringAttribute(true)]")
	end
end

describe AssemblyInfo, "when generating an assembly info file with the built in attributes" do
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		asm.company_name = @tester.company_name
		asm.product_name = @tester.product_name
		asm.version = @tester.version
		asm.title = @tester.title
		asm.description = @tester.description
		asm.copyright = @tester.copyright
		asm.com_visible = @tester.com_visible
		asm.com_guid = @tester.com_guid
		asm.file_version = @tester.file_version
		asm.trademark = @tester.trademark
		
		@filedata = @tester.build_and_read_assemblyinfo_file asm
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
	
	it "should contain the copyright information" do
		@filedata.should include("[assembly: AssemblyCopyright(\"#{@tester.copyright}\")]")
	end
	
	it "should contain the com visible information" do
		@filedata.should include("[assembly: ComVisible(#{@tester.com_visible})]")
		@filedata.should include("[assembly: Guid(\"#{@tester.com_guid}\")]")
	end
	
	it "should contain the company name information" do
		@filedata.should include("[assembly: AssemblyCompany(\"#{@tester.company_name}\")]")
	end
	
	it "should contain the product information" do
		@filedata.should include("[assembly: AssemblyProduct(\"#{@tester.product_name}\")]")
	end
	
	it "should contain the file version information" do
		@filedata.should include("[assembly: AssemblyFileVersion(\"#{@tester.file_version}\")]")
	end
	
	it "should contain the trademark information" do
		@filedata.should include("[assembly: AssemblyTrademark(\"#{@tester.trademark}\")]")
	end
end

describe AssemblyInfo, "when generating an assembly info file with no attributes provided" do
	before :all do
		@tester = AssemblyInfoTester.new
		asm = AssemblyInfo.new
		
		@filedata = @tester.build_and_read_assemblyinfo_file asm
	end
	
	it "should not contain the specified version information" do
		@filedata.should_not include("[assembly: AssemblyVersion(\"#{@tester.version}\")]")
	end
	
	it "should not contain the assembly title" do
		@filedata.should_not include("[assembly: AssemblyTitle(\"#{@tester.title}\")]")
	end
	
	it "should not contain the assembly description" do
		@filedata.should_not include("[assembly: AssemblyDescription(\"#{@tester.description}\")]")
	end
	
	it "should not contain the copyright information" do
		@filedata.should_not include("[assembly: AssemblyCopyright(\"#{@tester.copyright}\")]")
	end
	
	it "should not contain the com visible information" do
		@filedata.should_not include("[assembly: ComVisible(#{@tester.com_visible})]")
		@filedata.should_not include("[assembly: Guid(\"#{@tester.com_guid}\")]")
	end

	it "should not contain the company name information" do
		@filedata.should_not include("[assembly: AssemblyCompany(\"#{@tester.company_name}\")]")
	end

	it "should not contain the product information" do
		@filedata.should_not include("[assembly: AssemblyProduct(\"#{@tester.product_name}\")]")
	end
		
	it "should not contain the file version information" do
		@filedata.should_not include("[assembly: AssemblyFileVersion(\"#{@tester.file_version}\")]")
	end

	it "should not contain the trademark information" do
		@filedata.should_not include("[assembly: AssemblyTrademark(\"#{@tester.trademark}\")]")
	end
end

describe AssemblyInfo, "when configuring the assembly info generator with a yaml file" do
	before :all do
		tester = AssemblyInfoTester.new
		@asm = AssemblyInfo.new
		@asm.configure(tester.yaml_file)
	end
	
	it "should set the values for the provided attributes" do
		@asm.version.should == "0.0.1"
		@asm.company_name.should == "some company name"
	end
end
