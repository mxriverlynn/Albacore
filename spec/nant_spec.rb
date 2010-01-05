require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/nant'

@@nantpath = File.join(File.dirname(__FILE__), 'support', 'Tools', 'NAnt-0.85', 'bin', 'NAnt.exe')
@@build_output = File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'TestSolution', 'out', '0.0.1', 'debug', 'thefile.txt')

describe NAnt, "when running a nant task" do
  before :all do
    @nant = Nant.new()
    
    @nant.run
  end
  
  after :all do
    File.delete(@@build_output) if File.exists?(@@build_output)
  end
end