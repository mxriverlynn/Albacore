require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/command'
#require 'commandtestdata'

describe Command, "when executing a command with parameters" do
	before :all do
		@cmd = Command.new
		@cmd.extend(SystemPatch)
		@cmd.path_to_command = "dir"
		@cmd.parameters << [
			"*.*",
			"/s"
		]
		@cmd.execute
	end
	
	it "should run the command with the parameters" do
		@cmd.system_command.should include("\"dir\" *.* /s")
	end
end
