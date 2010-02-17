require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/assemblyinfo'
require 'rake/assemblyinfotask'
require 'fail_patch'

describe "when running" do
  before :all do
  	assemblyinfo :assemblyinfo do |asm|
      asm.extend(FailPatch)    
  	  @yielded_object = asm
  	end
    Rake::Task["assemblyinfo"].invoke
  end
  
  it "should yield the assembly info api" do
    @yielded_object.kind_of?(AssemblyInfo).should == true 
  end
end

describe "when execution fails" do
  before :all do
  	assemblyinfo :failingtask do |asm|
  	  asm.extend(FailPatch)
  	  asm.fail
  	end
    Rake::Task["failingtask"].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end
