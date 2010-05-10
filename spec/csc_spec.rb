require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/csc'

describe CSC, "when supplying a file list to compile" do
  before :each do
    csc = CSC.new
    csc.compile FileList["File1.cs", "File2.cs"]
  end

  it "should provide the file list to the compiler" do
    @system_command.should contain("\"File1.cs\"")
    @system_command.should contain("\"File2.cs\"")
  end
end
