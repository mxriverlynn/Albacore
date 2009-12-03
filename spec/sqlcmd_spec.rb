require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/sqlcmd'

describe SQLCmd, "when running a script file against a database with authentication information" do
	before :all do
		@cmd = SQLCmd.new
		@cmd.path_to_command = "sqlcmd.exe"
		@cmd.log_level = :verbose
		@cmd.extend(SystemPatch)
		@cmd.disable_system = true
		
		@cmd.server="a server"
		@cmd.database="a database"
		@cmd.username="some user"
		@cmd.password="shh! it's a secret!"
		@cmd.scripts << "somescript.sql"
		
		@cmd.run
	end
	
	it "should specify the location of the sqlcmd exe" do
		@cmd.system_command.should include("sqlcmd.exe")
	end
	
	it "should specify the script file" do
		@cmd.system_command.should include("-i \"somescript.sql\"")
	end
	
	it "should specify the server" do
		@cmd.system_command.should include("-S \"a server\"")
	end
	
	it "should specify the database" do
		@cmd.system_command.should include("-d \"a database\"")
	end

	it "should specify the username" do
		@cmd.system_command.should include("-U \"some user\"")
	end
	
	it "should specify the password" do
		@cmd.system_command.should include("-P \"shh! it's a secret!\"")
	end
end

describe SQLCmd, "when running with no command path specified" do
	before :all do
		strio = StringIO.new
		@cmd = SQLCmd.new
		@cmd.log_level = :verbose
		@cmd.log_device = strio
		@cmd.extend(SystemPatch)
		@cmd.disable_system = true
		
		@cmd.run
		@log_data = strio.string
	end
	
	it "should fail" do
		@cmd.failed.should be_true
	end
	
	it "should log a failure message" do
		@log_data.should include('SQLCmd.path_to_command cannot be nil.')
	end
end

describe SQLCmd, "when execution of sqlcmd fails" do
	before :all do
		strio = StringIO.new
		@cmd = SQLCmd.new
		@cmd.path_to_command="sqlcmd.exe"
		@cmd.log_level = :verbose
		@cmd.log_device = strio
		@cmd.extend(SystemPatch)
		@cmd.disable_system = true
		@cmd.force_system_failure = true
		
		@cmd.run
		@log_data = strio.string
	end
	
	
	it "should fail" do
		@cmd.failed.should be_true
	end
	
	it "should log a failure message" do
		@log_data.should include('SQLCmd Failed. See Build Log For Detail.')
	end
end

describe SQLCmd, "when running multiple script files" do
	before :all do
		@cmd = SQLCmd.new
		@cmd.path_to_command = "sqlcmd.exe"
		@cmd.log_level = :verbose
		@cmd.extend(SystemPatch)
		@cmd.disable_system = true
		
		@cmd.scripts << "did you get.sql"
		@cmd.scripts << "that thing.sql"
		@cmd.scripts << "i sent you.sql"
		
		@cmd.run
	end
	
	it "should specify the first script file" do
		@cmd.system_command.should include("-i \"did you get.sql\"")
	end

	it "should specify the second script file" do
		@cmd.system_command.should include("-i \"that thing.sql\"")
	end
	
	it "should specify the third script file" do
		@cmd.system_command.should include("-i \"i sent you.sql\"")
	end
end

describe SQLCmd, "when running with variables specified" do
	before :all do
		@cmd = SQLCmd.new
		@cmd.path_to_command = "sqlcmd.exe"
		@cmd.log_level = :verbose
		@cmd.extend(SystemPatch)
		@cmd.disable_system = true
		@cmd.scripts << "somescript.sql"
		
		@cmd.variables = {:myvar => "my value", :another_var => :another_value}
		
		@cmd.run
	end
	
	it "should supply the variables to sqlcmd" do
		@cmd.system_command.should include("-v myvar=my value")
		@cmd.system_command.should include("-v another_var=another_value")
	end
end
