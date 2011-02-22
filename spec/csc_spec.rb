require 'spec_helper'
require 'albacore/csc'

Albacore.configure do |config|
  config.log_level = :verbose
end

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

# TODO: If designed by contract this is an unncessary responsibility of the class.
# It should be removed and only validate that the parameter is being specified as CSC expects it.
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

describe CSC, "when configuring the version to use" do
  let :csc do
    Albacore.configure do |config|
      config.csc.use :net35
    end
    csc = CSC.new
    csc
  end

  it "should use the configured version" do
   win_dir = ENV['windir'] || ENV['WINDIR'] || "C:/Windows"
   csc.command.should == File.join(win_dir.dup, 'Microsoft.NET', 'Framework', 'v3.5', 'csc.exe')
  end
end

describe CSC, "when version to use has been configured and overriding" do
  let :csc do
    Albacore.configure do |config|
      config.csc.use :net2
    end
    csc = CSC.new
    csc.use :net35
    csc
  end

  it "should use the override version" do
   win_dir = ENV['windir'] || ENV['WINDIR'] || "C:/Windows"
   csc.command.should == File.join(win_dir.dup, 'Microsoft.NET', 'Framework', 'v3.5', 'csc.exe')
  end
end

describe CSC, "when specifying 2 resources to include" do
  let :csc do
    csc = CSC.new
    csc.resources "../some/file.resource", "another.resource"

    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should include the first resource" do
    csc.system_command.should include("/res:../some/file.resource")
  end

  it "should include the second resource" do
    csc.system_command.should include("/res:another.resource")
  end
end

describe CSC, "when specifying the optimize option" do
  let :csc do
    csc = CSC.new
    csc.optimize = true

    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should supply the optimize parameter" do
    csc.system_command.should include("/optimize")
  end
end

describe CSC, "when specifying debug information be generated" do
  let :csc do
    csc = CSC.new
    csc.debug = true

    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should provide the debug parameter" do
    csc.system_command.should include("/debug")
  end
end

describe CSC, "when specifying full debug information be generated" do
  let :csc do
    csc = CSC.new
    csc.debug = :full

    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should provide the full debug parameter" do
    csc.system_command.should include("/debug:full")
  end
end

describe CSC, "when specifying pdbonly debug information be generated" do
  let :csc do
    csc = CSC.new
    csc.debug = :pdbonly

    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should provide the pdbonly debug parameter" do
    csc.system_command.should include("/debug:pdbonly")
  end
end

describe CSC, "when specifying debug information not be generated" do
  let :csc do
    csc = CSC.new
    csc.debug = false

    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should not provide the debug parameter" do
    csc.system_command.should_not include("/debug")
  end
end

describe CSC, "when specifying an xml document to generate" do
  let :csc do
    csc = CSC.new
    csc.doc = "../path/to/docfile.xml"

    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should provide the documentation parmaeter" do
    csc.system_command.should include("/doc:../path/to/docfile.xml")
  end
end

describe CSC, "when defining processor symbols" do
  let :csc do
    csc = CSC.new
    csc.define :symbol1, :symbol2

    csc.extend(SystemPatch)
    csc.disable_system = true
    csc.execute
    csc
  end

  it "should specify the defined symbols" do
    csc.system_command.should include("/define:symbol1;symbol2")
  end
end

describe CSC, "when specifying main entry point be generated" do
	let :csc do
		csc = CSC.new
		csc.main = "Program.Main"

		csc.extend(SystemPatch)
		csc.disable_system = true
		csc.execute
		csc
	end

	it "should provide the main parameter" do
		csc.system_command.should include("/main:Program.Main")
	end
end

describe CSC, "when specifying main entry point not be generated" do
	let :csc do
		csc = CSC.new

		csc.extend(SystemPatch)
		csc.disable_system = true
		csc.execute
		csc
	end

	it "should not provide the main parameter" do
		csc.system_command.should_not include("/main")
	end
end
