require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/csc'

describe CSC, "when supplying a file list with 2 files to compile" do
  before :each do
    csc = CSC.new
    csc.compile FileList["File1.cs", "File2.cs"]
    csc.execute
  end

  it "should provide the first file to the compiler" do
    @system_command.should contain("\"File1.cs\"")
  end

  it "should provide the second file to the compiler" do
    @system_command.should contain("\"File2.cs\"")
  end
end
