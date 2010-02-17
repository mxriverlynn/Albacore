require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/assemblyinfo'
require 'rake/assemblyinfotask'
require 'tasklib_patch'

describe "when running" do
  before :all do
  	assemblyinfo :assemblyinfo do |asm|
      asm.extend(TasklibPatch)    
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
  	  asm.extend(TasklibPatch)
  	  asm.fail
  	end
    Rake::Task["failingtask"].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end

describe "when task args are used" do
  before :all do
    assemblyinfo :assemblytask_withargs, [:arg1] do |asm, args|
      asm.extend(TasklibPatch)
      @args = args
  	end
    Rake::Task["assemblytask_withargs"].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end