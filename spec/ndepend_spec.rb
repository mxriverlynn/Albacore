require 'spec_helper'
require 'albacore/ndepend'
require 'albacore/msbuild'

describe "when executing Ndepend console" do
  before :all do
    @msbuild = MSBuild.new
    @msbuild.properties = {:configuration => :Debug}
    @msbuild.targets = [:Clean, :Build]
    @msbuild.solution = "spec/support/TestSolution/TestSolution.sln"
    @msbuild.execute
  end
  before :each do
    @ndepend = NDepend.new
    @ndepend.log_device = StringIO.new
    @ndepend.project_file = "spec/support/TestSolution/NDependProject.xml"
    @ndepend.command = "spec/support/tools/Ndepend-v2.12/NDepend.Console.exe"

    @logger = StringIO.new
    @ndepend.log_device = @logger
    @log_data = @logger.string
    @ndepend.log_level = :verbose


  end
  it "should execute NdependConsole.exe"do
    @ndepend.execute

    @log_data.should include("NDepend.Console.exe" )
  end

  it "should include the Ndepend project file" do
    @ndepend.execute
    @log_data.should include("NDependProject.xml")
  end

  it "should fail when the project file is not given" do
    @ndepend.project_file = nil
    @ndepend.extend(FailPatch)
    @ndepend.execute
    $task_failed.should be_true
  end

  it "should accept other parameters" do
    expected_params = "/ViewReport /Silent /Help"
    @ndepend.parameters expected_params
    @ndepend.extend(FailPatch)
    @ndepend.execute
    @log_data.should include(expected_params)
  end

  it "should order command line properly by including ndepend project file first" do
    expected_params = "/Help"
    @ndepend.parameters expected_params
    @ndepend.extend(FailPatch)
    @ndepend.execute
    @log_data.should =~ /.*NDepend.Console.exe.*NDependProject.xml.*Help.*/
  end
end

describe NDepend, "when providing configuration" do
  let :ndepend do
    Albacore.configure do |config|
      config.ndepend.command = "configured"
    end
    ndepend = NDepend.new
  end

  it "should use the configured values" do
    ndepend.command.should == "configured"
  end
end
