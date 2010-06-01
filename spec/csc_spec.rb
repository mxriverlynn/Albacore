require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/csc'
Albacore::log_level = :verbose

describe CSC, "when supplying a file list with 2 files to compile" do
  let :csc do
    csc = CSC.new
    csc.compile = FileList["File1.cs", "File2.cs"]
    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should provide the first file to the compiler" do
    csc.system_command.should include("\"File1.cs\"")
  end

  it "should provide the second file to the compiler" do
    csc.system_command.should include("\"File2.cs\"")
  end
end

describe CSC, "when targeting a library and an output file" do 
  before :each do
    @folder = File.join(File.expand_path(File.dirname(__FILE__)), "support", "csc")
    csc = CSC.new
    csc.compile FileList[File.join(@folder, "File1.cs")]
    csc.target = :library
    csc.output = File.join(@folder, "output", "File1.dll")
    csc.execute
  end

  it "should produce the .dll file in the correct location" do
    File.exist?(File.join(@folder, "output", "File1.dll")).should be_true
  end
end

describe CSC, "when referencing existing assemblies" do
  let :csc do
    csc = CSC.new
    csc.references "foobar.dll"

    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should specify the reference on the command line" do
    csc.system_command.should include("\"/reference:foobar.dll\"")
  end
end
