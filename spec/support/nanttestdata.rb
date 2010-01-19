require 'albacore/nant'

class NAntTestData
  
  attr_accessor :nant_path, :build_file_path, :output_path
  
  def initialize(config_mode='Debug',version='0.0.1')
    @config_mode = config_mode
    @version = version
    
    @nant_path = File.join(File.dirname(__FILE__), "Tools", "NAnt-0.85", "bin", "NAnt.exe")
    @build_file_path = File.join(File.dirname(__FILE__), "TestSolution", "TestSolution.build")
    setup_output
  end
  
  def setup_output
    @output_root = File.join(File.dirname(__FILE__), "TestSolution", "out")
    @output_path = File.join(@output_root, "#{@version}", "#{@config_mode}")
    clean_output
  end
  
  def clean_output
    FileUtils.rm_rf @output_root
  end
  
  def nant
    @nant = NAnt.new
    
    @nant.extend(SystemPatch)
    @nant
  end
  
end
