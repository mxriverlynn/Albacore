require 'spec_helper'
require 'albacore/albacoretask'
require 'albacore/config/config'

class ConfigTest
  include Albacore::Task
end

module ConfigModuleTest
  include Albacore::Configuration

  def mixin_worked
    true
  end
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

describe "when including Albacore::Configuration in a module" do
  it "should mix the module into the Albacore.configuration" do
    Albacore.configuration.mixin_worked.should be_true
  end
end
