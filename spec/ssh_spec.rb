require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ssh'

describe Ssh, 'when executing a command over ssh' do
	before :all do
		Net::SSH.stub_method(:start) {  }
		Net::SSH.stub_method(:exec! => true)
	
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
		#Net::SSH.should have_received(:exec!)
	end
end

