require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'sqlcmd'
require 'sqlcmdtask'

describe Rake::SQLCmdTask, "when running" do
	before :all do
		Rake::SQLCmdTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the sqlcmd api" do
		@yielded_object.kind_of?(SQLCmd).should == true 
	end
end