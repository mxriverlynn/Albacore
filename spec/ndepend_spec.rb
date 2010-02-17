require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ndepend'
require 'albacore/msbuild'

describe "when executing Ndepend console" do
  before :all do
    @msbuild = MSBuild.new
    @msbuild.properties = {:configuration => :Debug}
    @msbuild.targets = [:Clean, :Build]
    @msbuild.solution = "spec/support/TestSolution/TestSolution.sln"
    @msbuild.build
  end
  before :each do
    @ndepend = NDepend.new
    @ndepend.log_device = StringIO.new
    @ndepend.project_file = "spec/support/TestSolution/NDependProject.xml"
    @ndepend.path_to_command = "spec/support/tools/Ndepend-v2.12/NDepend.Console.exe"

    @logger = StringIO.new
    @ndepend.log_device = @logger
    @log_data = @logger.string
    @ndepend.log_level = :verbose


  end
  it "should execute NdependConsole.exe"do
    @ndepend.run

    @log_data.should include("NDepend.Console.exe" )
  end

  it "should include the Ndepend project file" do
    @ndepend.run
    @log_data.should include("NDependProject.xml")
  end

  it "should fail when the project file is not given" do
    @ndepend.project_file = nil
    @ndepend.extend(FailPatch)
    @ndepend.run
    $task_failed.should be_true
  end

  it "should accept other parameters" do
    expected_params = "/ViewReport /Silent /Help"
    @ndepend.parameters expected_params
    @ndepend.extend(FailPatch)
    @ndepend.run
    @log_data.should include(expected_params)
  end
end