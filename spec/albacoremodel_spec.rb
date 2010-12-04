require 'spec_helper'
require 'albacore/albacoretask'

class ModelTest
  include Albacore::Task
  attr_accessor :foo, :bar
  attr_hash :a_hash
  attr_array :a_array
end

class NamedTaskExample
  TaskName = [:namedtask, :anothername]
  include Albacore::Task
end

describe "when updating object attributes with a valid set of hash keys" do
  before :each do
    @model = ModelTest.new
    @model << {:foo => "test", :bar => "whatever"}
  end

  it "should set the attributes correctly" do
    @model.foo.should == "test"
    @model.bar.should == "whatever"
  end
end

describe "when updating an object attributes with an invalid hash key" do
  before :each do
    @model = ModelTest.new
    str = StringIO.new
    @model.log_device = str
    @model << {:something => "broken"}
    @log = str.string
  end

  it "should warn about the attribute not being found" do
    @log.should include("something is not a settable attribute on ModelTest")
  end
end

describe "when an class includes albacoretask" do
  it "should create a rake task for that class" do
    respond_to?(:modeltest).should be_true
  end
end

describe "when an albacoretask class specifies task names" do
  it "should create a task with the specified names" do
    respond_to?(:namedtask).should be_true
    respond_to?(:anothername).should be_true
  end
end
