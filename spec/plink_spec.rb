require 'spec_helper'
require 'albacore/plink'

describe PLink, 'when executing a command over plink' do
  before :each do
    @cmd = PLink.new
    @cmd.extend(SystemPatch)
    @cmd.extend(FailPatch)
    @cmd.command ="C:\\plink.exe"
    @cmd.host = "testhost"

  end

  it "should attempt to execute plink.exe" do
    @cmd.run
    @cmd.system_command.should include("plink.exe")
  end

  it "should attempt to connect to the test host on the default port (22)"  do
    @cmd.run
    @cmd.system_command.should include("@testhost")
    @cmd.system_command.should include("-P 22")
  end

  it "should connect to the test host on a non default port 2200" do
    @cmd.port = 2200
    @cmd.run
    @cmd.system_command.should include("-P 2200")
  end

  it "should connect to the host with a username" do
    expected_user = "dummyuser"
    @cmd.user = expected_user
    @cmd.run
    @cmd.system_command.should include("#{expected_user}@")
  end

  it "should run remote commands in batch mode" do
    @cmd.run
    @cmd.system_command.should include("-batch")
  end

  it "should run commands in verbose mode" do
    @cmd.verbose = true
    @cmd.run
    @cmd.system_command.should include("-v")
  end

  it "should include the remote command" do
    expected_remote_exe = "C:\ThisIsTheRemoteExe.exe"
    @cmd.commands expected_remote_exe
    @cmd.run
    @cmd.system_command.should include(expected_remote_exe)
  end

  it "should include the remote command with parameters" do
    expected_remote_exe = "C:\\ThisIsTheRemoteExe.exe --help -o -p"
    @cmd.commands expected_remote_exe
    @cmd.run
    @cmd.system_command.should include(expected_remote_exe)
  end
end
