require 'albacore/support/albacore_helper'

class NAnt 
  extend AttrMethods
  include RunCommand
  include YAMLConfig
  include Logging
  
  attr_accessor :build_file
  
  def initialize
    super()
  end
  
  def run
    command_parameters = []
    command_parameters << "-buildfile:#{@build_file}" unless @build_file.nil? 
    
    result = run_command "NAnt", command_parameters.join(" ")
    
    failure_msg = 'NAnt task Failed. See Build Log For Detail.'
    fail_with_message failure_msg if !result
  end
  
end
