require 'lib/msbuild'
require 'lib/rake/msbuildtask'

describe "When running an msbuild rake task" do
	before :all do
		Rake::MSBuildTask.new() do |t|
			@yielded_object = t
		end
	end
	
	it "should yield the msbuild api" do
		@yielded_object.kind_of?(MSBuild).should == true 
	end
end
