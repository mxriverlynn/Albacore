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

describe "when an albacoremodel class finds a configuration file named after the class" do
  describe "and a module named after the class is found" do
    let :obj do
      ConfigTest.new
    end

    it "should include that configuration file's module" do
      obj.respond_to?(:hasbeenconfigured).should be_true
    end
  end
end

describe "when ruby files are present in the plugin directory (defaulted to {pwd}/albacore)" do
  let :obj do
    TestPlugin.new
  end

  it "should load the files" do
    obj.should_not be_nil
  end

  it "should load the config module for the plugins" do
    obj.configured.should be_true
  end
end
