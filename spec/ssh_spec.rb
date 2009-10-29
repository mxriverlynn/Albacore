require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/ssh'

describe Ssh, 'when executing a command over ssh' do
	before :each do
		@sshstub = Net::SSH::Connection::Session.stub_instance(:exec! => nil)
		Net::SSH.stub_method(:start, &lambda{}).yields(@sshstub)

		@ssh = Ssh.new
		@ssh.server="server"
		@ssh.username="user"
		@ssh.password="secret"
		@ssh.commands="execute THIS!"
		
		@ssh.execute
	end
	
	it "should attempt to open a connection with the supplied connection information" do
		Net::SSH.should have_received(:start)
	end
	
	it "should execute the command" do
		@sshstub.should have_received(:exec!)
	end
end

describe Ssh, "when executing multiple commands over ssh" do
	before :each do
		@sshstub = Net::SSH::Connection::Session.stub_instance(:exec! => nil)
		Net::SSH.stub_method(:start, &lambda{}).yields(@sshstub)

		@ssh = Ssh.new
		@ssh.server="server"
		@ssh.username="user"
		@ssh.password="secret"
		
		@ssh.commands << "execute THIS!"
		@ssh.commands << "another execution"
		
		@ssh.execute		
	end
	
	it "should execute all of the specified commands" do
		@sshstub.should have_received(:exec!).twice
	end
	
end

