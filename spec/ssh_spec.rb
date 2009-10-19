require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ssh'

describe Ssh, 'when executing a command over ssh' do
	before :all do
		@mockssh = mock
		@mockssh.expects(:exec!).with("execute THIS!")
		
		Net::SSH.expects(:start).yields(@mockssh)

		@ssh = Ssh.new
		@ssh.server="server"
		@ssh.username="user"
		@ssh.password="secret"
		@ssh.command="execute THIS!"
		
		@ssh.execute
	end
	
	after :all do
		
	end
	
	it "should attempt to open a connection with the supplied connection information" do
	end
	
	it "should execute the command" do
	end
end

