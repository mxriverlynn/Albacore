require 'spec_helper'
require 'albacore/nant'
require 'nanttestdata'

shared_context "prepping nant" do
  before :all do
    @testdata = NAntTestData.new
    @nant = @testdata.nant
    @strio = StringIO.new
    @nant.log_device = @strio
  end
  
  after :all do
    @testdata.clean_output
  end
end

describe NAnt, "when a nant path is not specified" do
  include_context "prepping nant"
  
  before :all do
  	@nant.extend(FailPatch)
    @log_data = @strio.string
    @nant.execute
  end
  
  it "should fail" do
  	$task_failed.should == true
  end
end

describe NAnt, "when running a nant build file" do
  include_context "prepping nant"
  
  before :all do
    @nant.command = @testdata.nant_path
    @nant.build_file = @testdata.build_file_path
    @nant.execute
  end
  
  it "should execute the default task" do
    File.exists?("#{@testdata.output_path}/buildfile.txt").should be_true
  end
end

describe NAnt, "when running specific targets" do
  include_context "prepping nant"
  
  before :all do
    @nant.command = @testdata.nant_path
    @nant.build_file = @testdata.build_file_path
    @nant.targets :build, :other
    @nant.execute
  end
  
  it "should execute the first task" do
    File.exists?("#{@testdata.output_path}/buildfile.txt").should be_true
  end
  
  it "should execute the second task" do
    File.exists?("#{@testdata.output_path}/otherfile.txt").should be_true
  end
end

describe NAnt, "when specifying multiple configuration properties" do
  
  before :all do
    @testdata = NAntTestData.new(:fast,"1.2.3")
    @nant = @testdata.nant
    @strio = StringIO.new
    @nant.log_device = @strio
    @nant.command = @testdata.nant_path
    @nant.build_file = @testdata.build_file_path
    
    @nant.properties :version => "1.2.3", "build.mode" => :fast, :debug => false
    @nant.execute
  end
  
  it "should spedify the first property" do
    @nant.system_command.should include("-D:version=1.2.3")
  end
  
  it "should spedify the second property" do
    @nant.system_command.should include("-D:build.mode=fast")
  end
  
  it "should spedify the last property" do
    @nant.system_command.should include("-D:debug=false")
  end
  
  it "should create the output file" do
    File.exists?("#{@testdata.output_path}/buildfile.txt").should be_true
  end
  
  after :all do
    @testdata.clean_output
  end
end

describe NAnt, "when providing configuration for nant" do
  let :nant do
    Albacore.configure do |config|
      config.nant.command = "configured"
    end
    nant = NAnt.new
  end
  it "should use the configured value" do
    nant.command.should == "configured"
  end
end
