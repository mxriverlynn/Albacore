require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'yamlconfig'

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