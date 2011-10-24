require 'spec_helper'
require 'support/assemblyinfotester'
require 'albacore/assemblyinfo'

shared_context "StringIO logging" do
  before :all do
    @strio = StringIO.new
  end

  def logwith_strio task, level = :diagnostic
    task.log_device = @strio
    task.log_level = level
  end
end

shared_context "asminfo task" do

  include_context "StringIO logging"

  before :all do
    @tester = AssemblyInfoTester.new
    @asm = AssemblyInfo.new
    logwith_strio @asm
  end
end

describe AssemblyInfo, "when generating an assembly info file" do

  include_context "asminfo task"

  before :all do
    @tester.build_and_read_assemblyinfo_file @asm
    @log_data = @strio.string
  end
  
  it "should log the name of the output file" do
    @log_data.downcase.should include(@tester.assemblyinfo_file.downcase)
  end
end

describe AssemblyInfo, "when generating an assembly info file in verbose mode" do

  include_context "asminfo task"

  before :all do
    @asm.version = @tester.version
    @tester.build_and_read_assemblyinfo_file @asm
  end

  subject { @strio.string }
  
  it "should log the name of the output file" do
    subject.downcase.should include(@tester.assemblyinfo_file.downcase)
  end
end

describe AssemblyInfo, "when generating an assembly info file without an output file specified" do

  include_context "asminfo task"

  before :all do
    @asm.extend(FailPatch)
    @asm.execute
  end

  subject { @strio.string }
  
  it "should log an error message saying the output file is required" do
    subject.should include("output_file cannot be nil")
  end
end

describe AssemblyInfo, "when providing a custom namespace without specifiying the language" do

  include_context "asminfo task"

  before :all do
    @asm.namespaces 'My.Name.Space'
  end

  subject {@tester.build_and_read_assemblyinfo_file @asm}

  it "should default to c# for the generated assemby info" do
    subject.scan('using My.Name.Space;').length.should == 1
  end
end

shared_context "language engines" do

  include_context "asminfo task"

  before :all do
    @asm.namespaces 'My.Name.Space', 'Another.Namespace.GoesHere'
  end

  def using_engine engine
    @tester.lang_engine = @asm.lang_engine = engine
  end

end

describe CSharpEngine, "when providing custom namespaces and specifying C#" do

  include_context "language engines"

  before :all do
    using_engine CSharpEngine.new
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

  it "should.execute the namespaces into the using statements" do
    subject.scan('using My.Name.Space;').length.should == 1
    subject.scan('using Another.Namespace.GoesHere;').length.should == 1
  end
end

describe VbNetEngine, "when providing custom namespaces and specifying VB.NET" do

  include_context "language engines"

  before :all do
    using_engine VbNetEngine.new
  end

  subject {@filedata = @tester.build_and_read_assemblyinfo_file @asm}

  it "should.execute the namespaces into the imports statements" do
    subject.scan('Imports My.Name.Space').length.should == 1
    subject.scan('Imports Another.Namespace.GoesHere').length.should == 1
  end
end

describe FSharpEngine, "when providing custom namespaces and specifying F#" do

  include_context "language engines"

  before :all do
    using_engine FSharpEngine.new
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

  it "should output the correct open statements" do
    subject.scan("open My.Name.Space").length.should == 1
    subject.scan("open Another.Namespace.GoesHere").length.should == 1
  end

end

shared_context "specifying custom attributes" do

  include_context "asminfo task"

  before :all do
    @asm.custom_attributes :CustomAttribute => "custom attribute data",
                           :AnotherAttribute => "more data here"
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

end

describe AssemblyInfo, "when providing custom attributes without specifying a language" do

  include_context "specifying custom attributes"

  it "should print the custom attributes to the assembly info file" do
    subject.scan('[assembly: CustomAttribute("custom attribute data")]').length.should == 1
    subject.scan('[assembly: AnotherAttribute("more data here")]').length.should == 1
  end

end

describe CSharpEngine, "when providing custom attributes and specifying C#" do

  include_context "language engines"
  include_context "specifying custom attributes"

  before :all do
    using_engine CSharpEngine.new
  end

  it "should print the custom attributes to the assembly info file" do
    subject.scan('[assembly: CustomAttribute("custom attribute data")]').length.should == 1
    subject.scan('[assembly: AnotherAttribute("more data here")]').length.should == 1
  end

end

describe VbNetEngine, "when providing custom attributes and specifying VB.NET" do

  include_context "language engines"
  include_context "specifying custom attributes"

  before :all do
    using_engine VbNetEngine.new
  end

  it "should print the custom attributes to the assembly info file" do
    subject.scan('<assembly: CustomAttribute("custom attribute data")>').length.should == 1
    subject.scan('<assembly: AnotherAttribute("more data here")>').length.should == 1
  end
end

describe FSharpEngine, "when providing custom attributes and specifying F#" do

  include_context "language engines"
  include_context "specifying custom attributes"

  before :all do
    using_engine FSharpEngine.new
  end

  it "should print the custom attributes to the assembly info file" do
    subject.scan('[<assembly: CustomAttribute("custom attribute data")>]').length.should == 1
    subject.scan('[<assembly: AnotherAttribute("more data here")>]').length.should == 1
  end
end


describe AssemblyInfo, "when specifying a custom attribute with no data" do

  include_context "asminfo task"

  before :all do
    @asm.custom_attributes :NoArgsAttribute => nil
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

  it "should.execute the attribute with an empty argument list" do
    subject.scan('[assembly: NoArgsAttribute()]').length.should == 1
  end
end

describe AssemblyInfo, "when specifying an attribute with non-string data" do

  include_context "asminfo task"

  before :all do
    @asm.custom_attributes :NonStringAttribute => true
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }
  
  it "should.execute the attribute data without quotes" do
    subject.scan('[assembly: NonStringAttribute(true)]').length.should == 1
  end
end

describe AssemblyInfo, "when generating an assembly info file with the built in attributes and no language specified" do

  include_context "asminfo task"

  before :all do
    @asm.product_name = @tester.product_name
    @asm.version = @tester.version
    @asm.title = @tester.title
    @asm.description = @tester.description
    @asm.copyright = @tester.copyright
    @asm.com_visible = @tester.com_visible
    @asm.com_guid = @tester.com_guid
    @asm.file_version = @tester.file_version
    @asm.trademark = @tester.trademark
    @asm.company_name = @tester.company_name
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

  it "should use the system.reflection namespace" do
    subject.scan('using System.Reflection;').length.should == 1
  end
  
  it "should use the system.runtime.interopservices namespace" do
    subject.scan('using System.Runtime.InteropServices;').length.should == 1
  end
  
  it "should contain the specified version information" do
    subject.scan(%Q|[assembly: AssemblyVersion("#{@tester.version}")]|).length.should == 1
  end
  
  it "should contain the assembly title" do
    subject.scan(%Q|[assembly: AssemblyTitle("#{@tester.title}")]|).length.should == 1
  end
  
  it "should contain the assembly description" do
    subject.scan(%Q|[assembly: AssemblyDescription("#{@tester.description}")|).length.should == 1
  end
  
  it "should contain the copyright information" do
    subject.scan(%Q|[assembly: AssemblyCopyright("#{@tester.copyright}")]|).length.should == 1
  end
  
  it "should contain the com visible information" do
    subject.scan(%Q|[assembly: ComVisible(#{@tester.com_visible})]|).length.should == 1
    subject.scan(%Q|[assembly: Guid("#{@tester.com_guid}")]|).length.should == 1
  end
  
  it "should contain the company name information" do
    subject.scan(%Q|[assembly: AssemblyCompany("#{@tester.company_name}")]|).length.should == 1
  end
  
  it "should contain the product information" do
    subject.scan(%Q|[assembly: AssemblyProduct("#{@tester.product_name}")]|).length.should == 1
  end
  
  it "should contain the file version information" do
    subject.scan(%Q|[assembly: AssemblyFileVersion("#{@tester.file_version}")]|).length.should == 1
  end
  
  it "should contain the trademark information" do
    subject.scan(%Q|[assembly: AssemblyTrademark("#{@tester.trademark}")]|).length.should == 1
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
