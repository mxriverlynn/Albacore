require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/zipdirectory'
require 'rake/ziptask'
require 'fail_patch'

describe "when running" do
  before :all do
    zip :zip do |t|
      t.extend(FailPatch)
      t.output_file = 'test.zip'
      @yielded_object = t
    end
    Rake::Task[:zip].invoke
  end
  
  it "should yield the zip api" do
    @yielded_object.kind_of?(ZipDirectory).should be_true
  end
end

describe "when execution fails" do
  before :all do
    zip :zip_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:zip_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end
