require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/nant'
require 'nanttestdata'

shared_examples_for "prepping nant" do
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
  it_should_behave_like "prepping nant"
  
  before :all do
  	@nant.extend(FailPatch)
    @log_data = @strio.string
    @nant.run
  end
  
  it "should fail" do
  	$task_failed.should == true
  end
  
  it "should log the missing command path" do
    @log_data.should include("Command not found: ")
  end
end

describe NAnt, "when running a nant build file" do
  it_should_behave_like "prepping nant"
  
  before :all do
    @nant.path_to_command = @testdata.nant_path
    @nant.build_file = @testdata.build_file_path
    @nant.run
  end
  
  it "should execute the default task" do
    File.exists?("#{@testdata.output_path}/buildfile.txt").should be true
  end
end

describe NAnt, "when running specific targets" do
  it_should_behave_like "prepping nant"
  
  before :all do
    @nant.path_to_command = @testdata.nant_path
    @nant.build_file = @testdata.build_file_path
    @nant.targets :build, :other
    @nant.run
  end
  
  it "should execute the first task" do
    File.exists?("#{@testdata.output_path}/buildfile.txt").should be true
  end
  
  it "should execute the second task" do
    File.exists?("#{@testdata.output_path}/otherfile.txt").should be true
  end
end

describe NAnt, "when specifying multiple configuration properties" do
  
  before :all do
    @testdata = NAntTestData.new(:fast,"1.2.3")
    @nant = @testdata.nant
    @strio = StringIO.new
    @nant.log_device = @strio
    @nant.path_to_command = @testdata.nant_path
    @nant.build_file = @testdata.build_file_path
    
    @nant.properties :version => "1.2.3", "build.mode" => :fast, :debug => false
    @nant.run
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
    File.exists?("#{@testdata.output_path}/buildfile.txt").should be true
  end
  
  after :all do
    @testdata.clean_output
  end
end