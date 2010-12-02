require 'spec_helper'
require 'albacore/mspectestrunner'

describe MSpecTestRunner, "when providing configuration" do
  let :mspec do
    Albacore.configure do |config|
      config.mspec.command = "test"
    end
    mspec = MSpecTestRunner.new
  end

  it "should use the configured values" do
    mspec.command.should == "test"
  end
end

describe MSpecTestRunner, "when overriding the command through the initializer" do
  let :mspec do
    Albacore.configure do |config|
      config.mspec.command = "configured"
    end
    mspec = MSpecTestRunner.new("override")
  end

  it "should use the command override" do
    mspec.command.should == "override"
  end
end
