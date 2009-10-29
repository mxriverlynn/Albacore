require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/support/yamlconfig'

class YamlTest
	include YAMLConfig
	attr_accessor :some_name
end

describe YAMLConfig, "when configuring with yaml" do
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

describe YAMLConfig, "when included yamlconfig in a class" do
	
	class YAML_AutoConfig_Test
		include YAMLConfig
	end
	
	before :all do
		@yamltest = YAML_AutoConfig_Test.new
	end
	
	it "should automatically configure the class through a yaml file named after the class" do
		@yamltest.this_attr_was_automatically_added_by.should == "the yaml auto config"
	end
end

describe YAMLConfig, "when extending a class with yamlconfig" do
	
	class YAML_AutoConfig_Test
	end
	
	before :all do
		@yamltest = YAML_AutoConfig_Test.new
		@yamltest.extend YAMLConfig
	end
	
	it "should automatically configure the class through a yaml file named after the class" do
		@yamltest.this_attr_was_automatically_added_by.should == "the yaml auto config"
	end
end