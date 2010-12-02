require 'spec_helper'
require 'albacore/xbuild'

describe XBuild, "when providing configuration values" do
  let :xbuild do
    Albacore.configure do |config|
      config.xbuild.command = "configured"
    end
    xbuild = XBuild.new
  end

  it "should use the configured values" do
    xbuild.command.should == "configured"
  end
end
