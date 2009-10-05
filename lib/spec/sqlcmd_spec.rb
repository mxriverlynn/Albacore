require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'sqlcmd'

describe SQLCmd, "when configuring with yaml" do
	
	before :all do
		@sql = SQLCmd.new
		@sql.configure File.join(File.dirname(__FILE__), 'support', 'sqlcmd.yml')
	end
	
	it "should set the location of the sqlcmd.exe" do
		@sql.path_to_command.should == "sqlcmd.exe"
	end
	
	it "should set the server name" do
		@sql.server.should == "localhost"
	end
			
	it "should set the database name" do
		@sql.database.should == "albacore"
	end
	
	it "should set the username" do
		@sql.username.should == "albacore"
	end
	
	it "should set the password" do
		@sql.password.should == "a1b@c0r3"
	end
end