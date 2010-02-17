require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/exec'
require 'rake/exectask'
require 'fail_patch'

describe "when running" do
  before :all do
  	exec :exec do |t|
  	  t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:exec].invoke
  end
  
  it "should yield the exec api" do
    @yielded_object.kind_of?(Exec).should == true 
  end
end

describe "when execution fails" do
  before :all do
  	exec :exec_fail do |t|
  	  t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:exec_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should be_true
  end
end

describe "when task args are used" do
  before :all do
    exec :exectask_withargs, [:arg1] do |exec, args|
      exec.extend(FailPatch)
      @args = args
  	end
    Rake::Task["exectask_withargs"].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end