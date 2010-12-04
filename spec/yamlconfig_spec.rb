require 'spec_helper'
require 'albacore/albacoretask'

class ::YamlTest
  include Albacore::Task
  attr_accessor :some_name, :another_name, :a_hash, :what_ever
end

describe "when configuring with yaml" do
  before :all do
    @yml = YamlTest.new
    @yml.configure File.join(File.dirname(__FILE__), 'support', 'test.yml')
  end
  
  it "should set the value of some_name" do
    @yml.some_name.should == "some value"
  end
  
  it "should create and set the value of another_name" do
    @yml.another_name.should == "another value"
  end
      
  it "should allow hash tables" do
    @yml.a_hash.length.should == 2
    @yml.a_hash['name'].should == "value"
    @yml.a_hash['foo'].should == "bar"
  end
  
  it "should allow symbols" do
    @yml.what_ever.should == :a_symbol
  end  
end

describe "when specifying a yaml config folder and configuring" do
  class ::YAML_AutoConfig_Test
    include Albacore::Task
    attr_accessor :some_attribute
  end
  
  before :all do
    Albacore.configure.yaml_config_folder = File.join(File.dirname(__FILE__), 'support', 'yamlconfig')
    @yamltest = YAML_AutoConfig_Test.new
    @yamltest.load_config_by_task_name("yaml_autoconfig_test")
  end
  
  it "should automatically configure the class from the yaml file in the specified folder" do
    @yamltest.some_attribute.should == "this value was loaded from a folder, specified by Albacore.configure.yaml_config_folder"
  end
end
