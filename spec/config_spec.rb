require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/albacoremodel'

class ConfigTest
  include AlbacoreModel
end

describe "when configuring log level to verbose" do
  let :test do
    Albacore.configure do |config|
      config.log_level = :verbose
    end
    test = ConfigTest.new
  end

  it "should set the log level for any model" do
    test.log_level.should == :verbose
  end
end
