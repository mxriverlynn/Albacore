require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/sftp'

describe Sftp, 'when uploading files over sftp' do
  before :each do
    @sftpstub = Net::SFTP::Session.stub_instance(:upload! => nil)
    Net::SFTP.stub_method(:start).yields(@sftpstub)

    @sftp = Sftp.new
    @sftp.server="server"
    @sftp.username="user"
    @sftp.password="secret"
    
    @sftp.upload_files(
      "some.file" => "./somefolder/some.file", 
      "another.file" => "another/folder/another.file"
    )
    
    @sftp.upload
  end
  
  it "should attempt to open a connection with the supplied connection information" do
    Net::SFTP.should have_received(:start).with("server", "user", :password => "secret")
  end
  
  it "should upload the local files to the remote destination" do
    @sftpstub.should have_received(:upload!).with("some.file", "./somefolder/some.file")
    @sftpstub.should have_received(:upload!).with("another.file", "another/folder/another.file")
  end
end
