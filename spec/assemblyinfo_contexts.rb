require 'spec_helper'
require 'support/assemblyinfotester'
require 'albacore/assemblyinfo'

shared_context "StringIO logging" do
  before :all do
    @strio = StringIO.new
  end

  def logwith_strio task, level = :diagnostic
    task.log_device = @strio
    task.log_level = level
  end
end

shared_context "asminfo task" do

  include_context "StringIO logging"

  before :all do
    @tester = AssemblyInfoTester.new
    @asm = AssemblyInfo.new
    logwith_strio @asm
  end
end

shared_context "language engines" do

  include_context "asminfo task"

  before :all do
    @asm.namespaces 'My.Name.Space', 'Another.Namespace.GoesHere'
  end

  def using_engine engine
    @tester.lang_engine = @asm.lang_engine = engine
  end

end

shared_context "specifying custom attributes" do

  include_context "asminfo task"

  before :all do
    @asm.custom_attributes :CustomAttribute => "custom attribute data",
                           :AnotherAttribute => "more data here"
  end

  subject { @tester.build_and_read_assemblyinfo_file @asm }

end