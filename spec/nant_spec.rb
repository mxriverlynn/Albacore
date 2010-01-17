require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/nant'

@@nantpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NAnt-0.85', 'bin', 'NAnt.exe')
@@build_file = File.join(File.dirname(__FILE__), 'support', 'TestSolution', 'TestSolution.build')
@@build_output = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'TestSolution', 'out', '0.0.1', 'debug', 'thefile.txt')

describe NAnt, "when running a nant task" do
  before :all do
    clean_output
    
    @nant = NAnt.new()
    @nant.path_to_command = @@nantpath
    @nant.build_file = @@build_file
    @nant.run
  end
  
  it "should execute the task" do
    File.exists?(@@build_output).should be true
  end
  
  after :all do
    clean_output
  end
  
  def clean_output
    File.delete(@@build_output) if File.exists?(@@build_output)
  end
end