require 'spec_helper'
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
    @log_data.downcase.should include(@tester.assemblyinfo_file.downcase)
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
    @log_data.downcase.should include(@tester.assemblyinfo_file.downcase)
  end
end

describe AssemblyInfo, "when generating an assembly info file without an output file specified" do
  before :all do
    @tester = AssemblyInfoTester.new
    asm = AssemblyInfo.new
    asm.extend(FailPatch)
    
    strio = StringIO.new
    asm.log_device = strio
    
    asm.execute

    @log_data = strio.string
  end
  
  it "should log an error message saying the output file is required" do
    @log_data.should include("output_file cannot be nil")
  end
end

describe AssemblyInfo, "when providing a custom namespace without specifiying the language" do 
  before :all do
    @tester = AssemblyInfoTester.new
    asm = AssemblyInfo.new    
    
    asm.namespaces 'My.Name.Space'

    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should default to c# for the generated assemby info" do
    @filedata.scan('using My.Name.Space;').length.should == 1
  end
end

describe AssemblyInfo, "when providing custom namespaces and specifying C#" do 
  before :all do
    @tester = AssemblyInfoTester.new
    @tester.lang_engine = CSharpEngine.new
    asm = AssemblyInfo.new
    asm.lang_engine = CSharpEngine.new
    
    asm.namespaces 'My.Name.Space', 'Another.Namespace.GoesHere'

    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should.execute the namespaces into the using statements" do
    @filedata.scan('using My.Name.Space;').length.should == 1
    @filedata.scan('using Another.Namespace.GoesHere;').length.should == 1
  end
end

describe AssemblyInfo, "when providing custom namespaces and specifying VB.NET" do 
  before :all do
    @tester = AssemblyInfoTester.new
    @tester.lang_engine = VbNetEngine.new
    asm = AssemblyInfo.new
    asm.lang_engine = VbNetEngine.new
    
    asm.namespaces 'My.Name.Space', 'Another.Namespace.GoesHere'

    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should.execute the namespaces into the imports statements" do
    @filedata.scan('Imports My.Name.Space').length.should == 1
    @filedata.scan('Imports Another.Namespace.GoesHere').length.should == 1
  end
end

describe AssemblyInfo, "when providing custom attributes without specifying a language" do  
  before :all do
    @tester = AssemblyInfoTester.new
    asm = AssemblyInfo.new
    
    asm.custom_attributes :CustomAttribute => "custom attribute data", :AnotherAttribute => "more data here"

    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should.execute the custom attributes to the assembly info file" do
    @filedata.scan('[assembly: CustomAttribute("custom attribute data")]').length.should == 1
    @filedata.scan('[assembly: AnotherAttribute("more data here")]').length.should == 1
  end
end

describe AssemblyInfo, "when providing custom attributes and specifying C#" do  
  before :all do
    @tester = AssemblyInfoTester.new
    @tester.lang_engine = CSharpEngine.new
    asm = AssemblyInfo.new
    asm.lang_engine = CSharpEngine.new
    
    asm.custom_attributes :CustomAttribute => "custom attribute data", :AnotherAttribute => "more data here"

    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should.execute the custom attributes to the assembly info file" do
    @filedata.scan('[assembly: CustomAttribute("custom attribute data")]').length.should == 1
    @filedata.scan('[assembly: AnotherAttribute("more data here")]').length.should == 1
  end
end

describe AssemblyInfo, "when providing custom attributes and specifying VB.NET" do  
  before :all do
    @tester = AssemblyInfoTester.new
    @tester.lang_engine = VbNetEngine.new
    asm = AssemblyInfo.new
    asm.lang_engine = VbNetEngine.new
    
    asm.custom_attributes :CustomAttribute => "custom attribute data", :AnotherAttribute => "more data here"

    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should.execute the custom attributes to the assembly info file" do
    @filedata.scan('<assembly: CustomAttribute("custom attribute data")>').length.should == 1
    @filedata.scan('<assembly: AnotherAttribute("more data here")>').length.should == 1
  end
end

describe AssemblyInfo, "when specifying a custom attribute with no data" do
  before :all do
    @tester = AssemblyInfoTester.new
    asm = AssemblyInfo.new
    
    asm.custom_attributes :NoArgsAttribute => nil

    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should.execute the attribute with an empty argument list" do
    @filedata.scan('[assembly: NoArgsAttribute()]').length.should == 1
  end
end

describe AssemblyInfo, "when specifying an attribute with non-string data" do
  before :all do
    @tester = AssemblyInfoTester.new
    asm = AssemblyInfo.new
    
    asm.custom_attributes :NonStringAttribute => true

    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should.execute the attribute data without quotes" do
    @filedata.scan('[assembly: NonStringAttribute(true)]').length.should == 1
  end
end

describe AssemblyInfo, "when generating an assembly info file with the built in attributes and no language specified" do
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
    
    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should use the system.reflection namespace" do
    @filedata.scan('using System.Reflection;').length.should == 1
  end
  
  it "should use the system.runtime.interopservices namespace" do
    @filedata.scan('using System.Runtime.InteropServices;').length.should == 1
  end
  
  it "should contain the specified version information" do
    @filedata.scan(%Q|[assembly: AssemblyVersion("#{@tester.version}")]|).length.should == 1
  end
  
  it "should contain the assembly title" do
    @filedata.scan(%Q|[assembly: AssemblyTitle("#{@tester.title}")]|).length.should == 1
  end
  
  it "should contain the assembly description" do
    @filedata.scan(%Q|[assembly: AssemblyDescription("#{@tester.description}")|).length.should == 1
  end
  
  it "should contain the copyright information" do
    @filedata.scan(%Q|[assembly: AssemblyCopyright("#{@tester.copyright}")]|).length.should == 1
  end
  
  it "should contain the com visible information" do
    @filedata.scan(%Q|[assembly: ComVisible(#{@tester.com_visible})]|).length.should == 1
    @filedata.scan(%Q|[assembly: Guid("#{@tester.com_guid}")]|).length.should == 1
  end
  
  it "should contain the company name information" do
    @filedata.scan(%Q|[assembly: AssemblyCompany("#{@tester.company_name}")]|).length.should == 1
  end
  
  it "should contain the product information" do
    @filedata.scan(%Q|[assembly: AssemblyProduct("#{@tester.product_name}")]|).length.should == 1
  end
  
  it "should contain the file version information" do
    @filedata.scan(%Q|[assembly: AssemblyFileVersion("#{@tester.file_version}")]|).length.should == 1
  end
  
  it "should contain the trademark information" do
    @filedata.scan(%Q|[assembly: AssemblyTrademark("#{@tester.trademark}")]|).length.should == 1
  end
end

describe AssemblyInfo, "when generating an assembly info file with the built in attributes and C# specified" do
  before :all do
    @tester = AssemblyInfoTester.new
    @tester.lang_engine = CSharpEngine.new
    asm = AssemblyInfo.new
    asm.lang_engine = CSharpEngine.new
    
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
    
    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should use the system.reflection namespace" do
    @filedata.scan('using System.Reflection;').length.should == 1
  end
  
  it "should use the system.runtime.interopservices namespace" do
    @filedata.scan('using System.Runtime.InteropServices;').length.should == 1
  end
  
  it "should contain the specified version information" do
    @filedata.scan(%Q|[assembly: AssemblyVersion("#{@tester.version}")]|).length.should == 1
  end
  
  it "should contain the assembly title" do
    @filedata.scan(%Q|[assembly: AssemblyTitle("#{@tester.title}")]|).length.should == 1
  end
  
  it "should contain the assembly description" do
    @filedata.scan(%Q|[assembly: AssemblyDescription("#{@tester.description}")]|).length.should == 1
  end
  
  it "should contain the copyright information" do
    @filedata.scan(%Q|[assembly: AssemblyCopyright("#{@tester.copyright}")]|).length.should == 1
  end
  
  it "should contain the com visible information" do
    @filedata.scan(%Q|[assembly: ComVisible(#{@tester.com_visible})]|).length.should == 1
    @filedata.scan(%Q|[assembly: Guid("#{@tester.com_guid}")]|).length.should == 1
  end
  
  it "should contain the company name information" do
    @filedata.scan(%Q|[assembly: AssemblyCompany("#{@tester.company_name}")]|).length.should == 1
  end
  
  it "should contain the product information" do
    @filedata.scan(%Q|[assembly: AssemblyProduct("#{@tester.product_name}")]|).length.should == 1
  end
  
  it "should contain the file version information" do
    @filedata.scan(%Q|[assembly: AssemblyFileVersion("#{@tester.file_version}")]|).length.should == 1
  end
  
  it "should contain the trademark information" do
    @filedata.scan(%Q|[assembly: AssemblyTrademark("#{@tester.trademark}")]|).length.should == 1
  end
end

describe AssemblyInfo, "when generating an assembly info file with the built in attributes and VB.NET specified" do
  before :all do
    @tester = AssemblyInfoTester.new
    @tester.lang_engine = VbNetEngine.new
    asm = AssemblyInfo.new
    asm.lang_engine = VbNetEngine.new
    
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
    
    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should use the system.reflection namespace" do
    @filedata.scan('Imports System.Reflection').length.should == 1
  end
  
  it "should use the system.runtime.interopservices namespace" do
    @filedata.scan('Imports System.Runtime.InteropServices').length.should == 1
  end
  
  it "should contain the specified version information" do
    @filedata.scan(%Q|<assembly: AssemblyVersion("#{@tester.version}")>|).length.should == 1
  end
  
  it "should contain the assembly title" do
    @filedata.scan(%Q|<assembly: AssemblyTitle("#{@tester.title}")>|).length.should == 1
  end
  
  it "should contain the assembly description" do
    @filedata.scan(%Q|<assembly: AssemblyDescription("#{@tester.description}")>|).length.should == 1
  end
  
  it "should contain the copyright information" do
    @filedata.scan(%Q|<assembly: AssemblyCopyright("#{@tester.copyright}")>|).length.should == 1
  end
  
  it "should contain the com visible information" do
    @filedata.scan(%Q|<assembly: ComVisible(#{@tester.com_visible})>|).length.should == 1
    @filedata.scan(%Q|<assembly: Guid("#{@tester.com_guid}")>|).length.should == 1
  end
  
  it "should contain the company name information" do
    @filedata.scan(%Q|<assembly: AssemblyCompany("#{@tester.company_name}")>|).length.should == 1
  end
  
  it "should contain the product information" do
    @filedata.scan(%Q|<assembly: AssemblyProduct("#{@tester.product_name}")>|).length.should == 1
  end
  
  it "should contain the file version information" do
    @filedata.scan(%Q|<assembly: AssemblyFileVersion("#{@tester.file_version}")>|).length.should == 1
  end
  
  it "should contain the trademark information" do
    @filedata.scan(%Q|<assembly: AssemblyTrademark("#{@tester.trademark}")>|).length.should == 1
  end
end

describe AssemblyInfo, "when generating an assembly info file with no attributes provided" do
  before :all do
    @tester = AssemblyInfoTester.new
    asm = AssemblyInfo.new
    
    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should not contain the specified version information" do
    @filedata.scan(%Q|[assembly: AssemblyVersion("#{@tester.version}")]|).should be_empty
  end
  
  it "should not contain the assembly title" do
    @filedata.scan(%Q|[assembly: AssemblyTitle("#{@tester.title}")]|).should be_empty
  end
  
  it "should not contain the assembly description" do
    @filedata.scan(%Q|[assembly: AssemblyDescription("#{@tester.description}")]|).should be_empty
  end
  
  it "should not contain the copyright information" do
    @filedata.scan(%Q|[assembly: AssemblyCopyright("#{@tester.copyright}")]|).should be_empty
  end
  
  it "should not contain the com visible information" do
    @filedata.scan(%Q|[assembly: ComVisible(#{@tester.com_visible})]|).should be_empty
    @filedata.scan(%Q|[assembly: Guid("#{@tester.com_guid}")]|).should be_empty
  end

  it "should not contain the company name information" do
    @filedata.scan(%Q|[assembly: AssemblyCompany("#{@tester.company_name}")]|).should be_empty
  end

  it "should not contain the product information" do
    @filedata.scan(%Q|[assembly: AssemblyProduct("#{@tester.product_name}")]|).should be_empty
  end
    
  it "should not contain the file version information" do
    @filedata.scan(%Q|[assembly: AssemblyFileVersion("#{@tester.file_version}")]|).should be_empty
  end

  it "should not contain the trademark information" do
    @filedata.scan(%Q|[assembly: AssemblyTrademark("#{@tester.trademark}")]|).should be_empty
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

describe AssemblyInfo, "when assembly info configuration is provided" do
  let :asm do
    Albacore.configure do |config|
      config.assemblyinfo do |asm|
        asm.company_name = "foo"
        asm.version = "bar"
      end
    end
    AssemblyInfo.new
  end
  it "should use the supplied info" do
    asm.company_name.should == "foo"
    asm.version.should == "bar"
  end
end

describe AssemblyInfo, "when specifying custom data" do
  before :all do
    @tester = AssemblyInfoTester.new
    asm = AssemblyInfo.new
    
    asm.custom_data "// foo", "// bar"

    # Generate the same file twice.
    @tester.build_and_read_assemblyinfo_file asm
    @filedata = @tester.build_and_read_assemblyinfo_file asm
  end
  
  it "should write data unmodified to the output" do
    @filedata.scan('// foo').length.should == 1
    @filedata.scan('// bar').length.should == 1
  end
end

describe AssemblyInfo, "when an input file is provided" do
    before :all do
       @tester = AssemblyInfoTester.new
       asm = AssemblyInfo.new

       asm.version = @tester.version
       asm.file_version = @tester.file_version

       asm.custom_data "// foo", "// baz"

       # make it use existing file
       @tester.use_input_file
       
       # Generate the same file twice.
       @tester.build_and_read_assemblyinfo_file asm
       @filedata = @tester.build_and_read_assemblyinfo_file asm
    end
    it "should contain correct version attribute" do
       @filedata.scan(%Q|[assembly: AssemblyVersion("#{@tester.version}")]|).length.should == 1
    end
    it "shoud leave comment untouched" do
       @filedata.scan(%Q|// A comment we want to see maintained|).length.should == 1
    end
    it "should introduce a new fileversion attribute" do
       @filedata.scan(%Q|[assembly: AssemblyFileVersion("#{@tester.file_version}")]|).length.should == 1
    end
    it "should still leave custom data that's already in there intact" do
       @filedata.scan(%Q|// foo|).length.should == 1
    end
    it "should add custom data that's still missing" do
       @filedata.scan(%Q|// baz|).length.should == 1
    end
end
