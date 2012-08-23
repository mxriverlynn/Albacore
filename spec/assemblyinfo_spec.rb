require 'spec_helper'
require 'support/assemblyinfotester'
require 'albacore/assemblyinfo'
require 'assemblyinfo_contexts'
# have a look in the above file to see what spec types are in this file

describe AssemblyInfo, "when generating an assembly info file" do

  include_context "asminfo task"

  before :all do
    @tester.build_and_read_assemblyinfo_file @asm
  end

  subject { @strio.string }
  
  it "should log the name of the output file" do
    subject.downcase.should include(@tester.assemblyinfo_file.downcase)
  end
end

describe AssemblyInfo, "when generating an assembly info file in verbose mode" do

  include_context "asminfo task"

  before :all do
    @asm.version = @tester.version
    logwith_strio @asm, :verbose
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

describe FSharpEngine, "when generating assembly info" do

  include_context "language engines"

  before :all do
    using_engine FSharpEngine.new
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

  it "should output a module definition" do
    subject.scan('module AssemblyInfo').length.should == 1
  end

  it "should output '()' at the bottom" do
    subject.scan('()').length.should == 1
  end

end

describe FSharpEngine, "when setting language attribute" do

  include_context "language engines"

  before :all do
    @tester.language = @asm.language = "F#"
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

  it "should use the system.reflection namespace" do
    subject.scan(%Q|open System.Reflection|).length.should == 1
  end

  it "should not contain the assembly title" do
    subject.scan(%Q|[assembly: AssemblyTitle("#{@tester.title}")]|).should be_empty
  end

  it "should output a module definition" do
    subject.scan('module AssemblyInfo').length.should == 1
  end

  it "should output '()' at the bottom" do
    subject.scan('()').length.should == 1
  end

end





{ :no => { :engine => nil,              :lang => "no", :start_token => "[", :end_token => "]",     :using => "using " },
  :cs => { :engine => CSharpEngine.new, :lang => "the C#", :start_token => "[", :end_token => "]",     :using => "using " },
  :vb => { :engine => VbNetEngine.new,  :lang => "the VB.Net", :start_token => "<", :end_token => ">", :using => "Imports " },
  :fs => { :engine => FSharpEngine.new, :lang => "the F#", :start_token => "[<", :end_token => ">]",   :using => "open " },
  :cpp=> { :engine => CppCliEngine.new, :lang => "the C++", :start_token => "[", :end_token => "]",    :using => "using namespace ", :nsdelim => "::" }
}.each do |key, settings|

  describe AssemblyInfo, "when generating an assembly info file with the built in attributes and #{settings[:lang]} language specified" do

    include_context "language engines"

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

      using_engine settings[:engine] unless settings[:engine].nil?
    end

    let(:s) { settings[:start_token] }
    let(:e) { settings[:end_token] }
    let(:using) { settings[:using] }
    let(:d) { settings[:nsdelim] || '.' }

    subject { @tester.build_and_read_assemblyinfo_file @asm }

    it "should use the system.reflection namespace" do
      subject.scan(%Q|#{using}System#{d}Reflection|).length.should == 1
    end

    it "should use the system.runtime.interopservices namespace" do
      subject.scan(%Q|#{using}System#{d}Runtime#{d}InteropServices|).length.should == 1
    end

    it "should use custom namespaces" do
      subject.scan(%Q|#{using}My#{d}Name#{d}Space|).length.should == 1
    end

    it "shold be using the other custom namespace, too" do
      subject.scan(%Q|#{using}Another#{d}Namespace#{d}GoesHere|).length.should == 1
    end

    it "should contain the specified version information" do
      subject.scan(%Q|#{s}assembly: AssemblyVersion("#{@tester.version}")#{e}|).length.should == 1
    end

    it "should contain the assembly title" do
      subject.scan(%Q|#{s}assembly: AssemblyTitle("#{@tester.title}")#{e}|).length.should == 1
    end

    it "should contain the assembly description" do
      subject.scan(%Q|#{s}assembly: AssemblyDescription("#{@tester.description}")#{e}|).length.should == 1
    end

    it "should contain the copyright information" do
      subject.scan(%Q|#{s}assembly: AssemblyCopyright("#{@tester.copyright}")#{e}|).length.should == 1
    end

    it "should contain the com visible information" do
      subject.scan(%Q|#{s}assembly: ComVisible(#{@tester.com_visible})#{e}|).length.should == 1
      subject.scan(%Q|#{s}assembly: Guid("#{@tester.com_guid}")#{e}|).length.should == 1
    end

    it "should contain the company name information" do
      subject.scan(%Q|#{s}assembly: AssemblyCompany("#{@tester.company_name}")#{e}|).length.should == 1
    end

    it "should contain the product information" do
      subject.scan(%Q|#{s}assembly: AssemblyProduct("#{@tester.product_name}")#{e}|).length.should == 1
    end

    it "should contain the file version information" do
      subject.scan(%Q|#{s}assembly: AssemblyFileVersion("#{@tester.file_version}")#{e}|).length.should == 1
    end

    it "should contain the trademark information" do
      subject.scan(%Q|#{s}assembly: AssemblyTrademark("#{@tester.trademark}")#{e}|).length.should == 1
    end
  end
end

describe AssemblyInfo, "when generating an assembly info file with no attributes provided" do
  include_context "asminfo task"

  subject do
    @tester.build_and_read_assemblyinfo_file @asm
  end
  
  it "should not contain the specified version information" do
    subject.scan(%Q|[assembly: AssemblyVersion("#{@tester.version}")]|).should be_empty
  end
  
  it "should not contain the assembly title" do
    subject.scan(%Q|[assembly: AssemblyTitle("#{@tester.title}")]|).should be_empty
  end
  
  it "should not contain the assembly description" do
    subject.scan(%Q|[assembly: AssemblyDescription("#{@tester.description}")]|).should be_empty
  end
  
  it "should not contain the copyright information" do
    subject.scan(%Q|[assembly: AssemblyCopyright("#{@tester.copyright}")]|).should be_empty
  end
  
  it "should not contain the com visible information" do
    subject.scan(%Q|[assembly: ComVisible(#{@tester.com_visible})]|).should be_empty
    subject.scan(%Q|[assembly: Guid("#{@tester.com_guid}")]|).should be_empty
  end

  it "should not contain the company name information" do
    subject.scan(%Q|[assembly: AssemblyCompany("#{@tester.company_name}")]|).should be_empty
  end

  it "should not contain the product information" do
    subject.scan(%Q|[assembly: AssemblyProduct("#{@tester.product_name}")]|).should be_empty
  end
    
  it "should not contain the file version information" do
    subject.scan(%Q|[assembly: AssemblyFileVersion("#{@tester.file_version}")]|).should be_empty
  end

  it "should not contain the trademark information" do
    subject.scan(%Q|[assembly: AssemblyTrademark("#{@tester.trademark}")]|).should be_empty
  end
end

describe AssemblyInfo, "when configuring the assembly info generator with a yaml file" do
  before :all do
    @asm = AssemblyInfo.new
    @asm.configure(AssemblyInfoTester.new.yaml_file)
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

  include_context "asminfo task"

  before :all do
    @asm.custom_data "// foo", "// bar"
  end

  subject{ @tester.build_and_read_assemblyinfo_file @asm }
  
  it "should write data unmodified to the output" do
    subject.scan('// foo').length.should == 1
    subject.scan('// bar').length.should == 1
  end
end

describe AssemblyInfo, "when an input file is provided" do

  include_context "asminfo task"

  before :all do
     @asm.version = @tester.version
     @asm.file_version = @tester.file_version

     @asm.custom_data "// foo", "// baz"

     # make it use existing file
     @tester.use_input_file
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

  it "should contain correct version attribute" do
     subject.scan(%Q|[assembly: AssemblyVersion("#{@tester.version}")]|).length.should == 1
  end
  it "shoud leave comment untouched" do
     subject.scan(%Q|// A comment we want to see maintained|).length.should == 1
  end
  it "should introduce a new fileversion attribute" do
     subject.scan(%Q|[assembly: AssemblyFileVersion("#{@tester.file_version}")]|).length.should == 1
  end
  it "should still leave custom data that's already in there intact" do
     subject.scan(%Q|// foo|).length.should == 1
  end
  it "should add custom data that's still missing" do
     subject.scan(%Q|// baz|).length.should == 1
  end
end

describe AssemblyInfo, "when an input file is provided with no attributes" do

  include_context "asminfo task"

  before :all do
    @asm.company_name = nil
    @asm.version = nil

    # make it use existing file
    @tester.use_input_file
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

  # will give a false-positive if input file has no blank lines at the bottom
  it "should output one blank line at the bottom" do
    subject.scan(/[^\n]\n\z/).length.should == 1
  end
end
