require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/command'

@@nunit = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NUnit-v2.5', 'nunit-console-x86.exe')

describe Command, "when executing a command with parameters" do
	before :all do
		@cmd = Command.new
		@cmd.log_level = :verbose
		@cmd.extend(SystemPatch)
		@cmd.path_to_command = @@nunit
		@cmd.parameters << ["--help"]
		@cmd.execute
	end
	
	it "should run the command with the parameters" do
		@cmd.system_command.should include("\"#{@@nunit}\" --help")
	end
	
	it "should not fail" do
		@cmd.failed.should be_false
	end
end
