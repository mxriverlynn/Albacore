require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ssh'

describe Ssh, 'when executing a command over ssh' do
	before :each do
		@sshstub = Net::SSH::Connection::Session.stub_instance(:exec! => "executed a command over ssh")
		Net::SSH.stub_method(:start, &lambda{}).yields(@sshstub)

		@ssh = Ssh.new
		@ssh.server="server"
		@ssh.username="user"
		@ssh.password="secret"
		@ssh.command="execute THIS!"
		
		@ssh.execute
	end
	
	it "should attempt to open a connection with the supplied connection information" do
		Net::SSH.should have_received(:start)
	end
	
	it "should execute the command" do
		@sshstub.should have_received(:exec!)
	end
end

