require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/csc'
Albacore::log_level = :verbose

describe CSC, "when supplying a file list with 2 files to compile" do
  before :each do
    config = CSCConfig.new
    config.compile = FileList["File1.cs", "File2.cs"]

    @csc = CSC.new
    @csc.extend(SystemPatch)
    @csc.disable_system = true
    @csc.execute(config)
  end

  it "should provide the first file to the compiler" do
    @csc.system_command.should include("\"File1.cs\"")
  end

  it "should provide the second file to the compiler" do
    @csc.system_command.should include("\"File2.cs\"")
  end
end
