require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ndepend'

describe "when executing Ndepend console" do
  before :each do
    @ndepend = NDepend.new
    @ndepend.log_device = StringIO.new
    @ndepend.project_file = "support/projectfile.xml"
    @ndepend.extend(SystemPatch)
    @ndepend.path_to_command = "support/NdependConsole.exe"

  end
  it "should execute NdependConsole.exe"do
    @ndepend.run
    @ndepend.system_command.should include("NdependConsole.exe" )
  end

  it "should include the Ndepend project file" do
    @ndepend.run
    @ndepend.system_command.should include("projectfile.xml")
  end

  it "should fail when the project file is not given" do
    @ndepend.project_file = nil
    @ndepend.run
    @ndepend.failed.should be_true
  end

  it "should accept other parameters" do
    expected_params = "/ViewReport /Silent /Help"
    @ndepend.parameters << expected_params
    @ndepend.run
    @ndepend.system_command.should include(expected_params)
  end
end