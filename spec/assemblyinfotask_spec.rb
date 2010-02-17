require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/assemblyinfo'
require 'rake/assemblyinfotask'
require 'tasklib_patch'

describe "when running" do
  before :all do
  	assemblyinfo :assemblyinfo do |asm|
  	  puts "::::::::::::::::::::::#{asm}"
  	  @yielded_object = asm
  	end
    @task = Rake::Task["assemblyinfo"]
    @task.extend(TasklibPatch)    
    @task.invoke
  end
  
  it "should yield the assembly info api" do
    @yielded_object.kind_of?(AssemblyInfo).should == true 
  end
end
