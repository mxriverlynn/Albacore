require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'assemblyinfo'
require 'assemblyinfotask'

describe Rake::AssemblyInfoTask, "when running" do
	before :all do
		Rake::AssemblyInfoTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the assembly info api" do
		@yielded_object.kind_of?(AssemblyInfo).should == true 
	end
end