require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'ncoverconsole'
require 'ncoverconsoletask'

describe Rake::NCoverConsoleTask, "when running" do
	before :all do
		Rake::NCoverConsoleTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the ncover console api" do
		@yielded_object.kind_of?(NCoverConsole).should == true 
	end
end