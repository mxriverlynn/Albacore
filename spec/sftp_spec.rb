require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'sftp'

describe Sftp, 'when uploading a file over sftp' do
	before :each do
		@sftpstub = Net::SFTP::Session.stub_instance(:upload! => nil)
		Net::SFTP.stub_method(:start).yields(@sftpstub)

		@sftp = Sftp.new
		@sftp.server="server"
		@sftp.username="user"
		@sftp.password="secret"
		@sftp.local_file = "some.file"
		@sftp.remote_file = "./somefolder/some.file"
		
		@sftp.upload
	end
	
	it "should attempt to open a connection with the supplied connection information" do
		Net::SFTP.should have_received(:start).with("server", "user", :password => "secret")
	end
	
	it "should upload the local file to the remote destination" do
		@sftpstub.should have_received(:upload!).with("some.file", "./somefolder/some.file")
	end
end
