require 'spec_helper'
require 'albacore/nchurn'
require 'patches/system_patch'

class NChurn
  attr_accessor :failure_message

  def fail_with_message(m)
    @failure_message = m
  end
end

class NChurnTestData
  attr_reader :nchurn_command
  attr_reader :output_text
  def initialize
    @nchurn_command = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NChurn-v0.4', 'nchurn.exe')
    @output_text = 'nchurn-test.txt'
    
  end

  def remove!
    FileUtils.rm @output_text if File.exist? @output_text
  end
end

describe NChurn, "when running nchurn" do  
  before :all do
    @nchurn = NChurn.new
    @nchurn.extend SystemPatch
    @test_data = NChurnTestData.new
    @test_data.remove!

  end

  before :each do
    @nchurn.failure_message = nil
  end

  it "should fail with no command" do
    @nchurn.execute
    @nchurn.failure_message.should eql('Churn Analysis Failed. See Build Log For Detail.')
  end

  it "should succeed and redirect to file" do
    @nchurn.command = NChurnTestData.new.nchurn_command
    @nchurn.output @test_data.output_text

    @nchurn.execute
    @nchurn.failure_message.should be_nil
    File.exist?(@test_data.output_text).should be_true
  end

  it "should pass all parameters correctly" do
    @nchurn.command = "nchurn.exe" 
    @nchurn.disable_system = true
    @nchurn.output @test_data.output_text
    @nchurn.input "file.txt"
  
    @nchurn.churn_precent 30
    @nchurn.top 10
    @nchurn.report_as :xml
    @nchurn.env_path 'c:/tools'
    @nchurn.adapter :git
    @nchurn.exclude "exe"
    @nchurn.include "foo"

    @nchurn.execute
    @nchurn.failure_message.should be_nil
    cmd = %{"nchurn.exe" -i "file.txt" -c 0.3 -t 10 -r xml -p "c:/tools" -a git -x "exe" -n "foo" > "nchurn-test.txt"}
    @nchurn.system_command.should eql(cmd)
  end

end

