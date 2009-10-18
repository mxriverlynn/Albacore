require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ssh'

describe Ssh, 'when executing a command over ssh' do
	before :all do
		@mockssh = mock
		
		@ssh = Ssh.new
		@ssh.server="server"
		@ssh.username="user"
		@ssh.password="secret"
		@ssh.command="execute THIS!"
	end
	
	after :all do
		@ssh.execute
	end
	
	it "should attempt to open a connection with the supplied connection information" do
		Net::SSH.expects(:start).yields(@mockssh)
	end
	
	it "should execute the command" do
		@mockssh.expects(:exec!).with("execute THIS!")
	end
end

