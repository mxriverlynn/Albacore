require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/msbuild'
require 'msbuildtestdata'

shared_examples_for "prepping msbuild" do
  before :all do
    @testdata = MSBuildTestData.new
    @msbuild = @testdata.msbuild
    @strio = StringIO.new
    @msbuild.log_device = @strio
    @msbuild.log_level = :verbose
  end
end

describe MSBuild, "when building a solution with verbose logging turned on" do  
  it_should_behave_like "prepping msbuild"
  
  before :all do
    @msbuild.solution = @testdata.solution_path
    @msbuild.build
    
    @log_data = @strio.string
  end

  it "should log the msbuild command line being called" do
    @log_data.should include("Executing MSBuild: \"C:\\Windows/Microsoft.NET/Framework/v3.5/MSBuild.exe\"")
  end
end

describe MSBuild, "when building with no solution specified" do
  it_should_behave_like "prepping msbuild"

  before :all do
    @msbuild.extend(FailPatch)
    @msbuild.build
    @log_data = @strio.string
  end
  
  it "should log an error message saying the output file is required" do
    @log_data.should include("solution cannot be nil")
  end
end

describe MSBuild, "when an msbuild path is not specified" do
  before :all do
    @testdata = MSBuildTestData.new
    @msbuild = @testdata.msbuild
  end
  
  it "should default to the .net framework v3.5" do
    @msbuild.path_to_command.should == @testdata.msbuild_path
  end
end

describe MSBuild, "when an msbuild path is specified" do
  before :all do
    @testdata = MSBuildTestData.new
    @msbuild = @testdata.msbuild "Some Path"
  end
  
  it "should use the specified path for the msbuild exe" do
    @msbuild.path_to_command.should == "Some Path"
  end  
end

describe MSBuild, "when an invalid msbuild path is specified" do
  before :all do
    @testdata = MSBuildTestData.new
    msbuild = @testdata.msbuild "/an invalid path/does not exist.exe"
    msbuild.extend(FailPatch)
    @strio = StringIO.new
    msbuild.log_device = @strio
    msbuild.log_level = :verbose
    msbuild.solution = @testdata.solution_path
    
    msbuild.build

    @log_data = @strio.string
  end
  
  it "should log an error message saying the command was not found" do
    @log_data.should include("Command not found: #{@testdata.msbuild_path}")
  end
end

describe MSBuild, "when building a visual studio solution" do
  it_should_behave_like "prepping msbuild"

  before :all do
    @msbuild.solution = @testdata.solution_path
    @msbuild.build
  end
  
  it "should output the solution's binaries" do
    File.exist?(@testdata.output_path).should == true
  end
end

describe MSBuild, "when building a visual studio solution with a single target" do
  it_should_behave_like "prepping msbuild"

  before :all do
    @msbuild.solution = @testdata.solution_path
    @msbuild.targets :Rebuild
    @msbuild.build
  end
  
  it "should output the solution's binaries" do
    File.exist?(@testdata.output_path).should == true
  end
end

describe MSBuild, "when building a visual studio solution for a specified configuration" do
  before :all do
    @testdata= MSBuildTestData.new("Release")
    @msbuild = @testdata.msbuild
    
    @msbuild.properties :configuration => :Release
    @msbuild.solution = @testdata.solution_path
    @msbuild.build
  end
  
  it "should build with the specified configuration as a property" do
    @msbuild.system_command.should include("/p:configuration=\"Release\"")
  end
  
  it "should output the solution's binaries according to the specified configuration" do
    File.exist?(@testdata.output_path).should be_true
  end
end

describe MSBuild, "when specifying targets to build" do  
  it_should_behave_like "prepping msbuild"

  before :all do
    @msbuild.targets :Clean, :Build
    @msbuild.solution = @testdata.solution_path
    @msbuild.build
  end

  it "should build the targets" do
    @msbuild.system_command.should include("/target:Clean;Build")
  end

end

describe MSBuild, "when building a solution with a specific msbuild verbosity" do
  it_should_behave_like "prepping msbuild"

  before :all do
    @msbuild.verbosity = "normal"
    @msbuild.solution = @testdata.solution_path
    @msbuild.build
  end

  it "should call msbuild with the specified verbosity" do
    @msbuild.system_command.should include("/verbosity:normal")
  end
end

describe MSBuild, "when specifying multiple configuration properties" do  
  it_should_behave_like "prepping msbuild"

  before :all do
    File.delete(@testdata.output_path) if File.exist?(@testdata.output_path)
    
    @msbuild.targets :Clean, :Build
    @msbuild.properties :configuration => :Debug, :DebugSymbols => true 
    @msbuild.solution = @testdata.solution_path
    @msbuild.build
  end

  it "should specify the first property" do
    @msbuild.system_command.should include("/p:configuration=\"Debug\"")
  end
  
  it "should specifiy the second property" do
    @msbuild.system_command.should include("/p:DebugSymbols=\"true\"")
  end
  
  it "should output the solution's binaries" do
    File.exist?(@testdata.output_path).should == true
  end
end
