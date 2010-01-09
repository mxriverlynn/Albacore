require 'albacore/support/albacore_helper'

class Exec
  include AttrMethods
  include RunCommand
  include YAMLConfig
  include Logging
  
  attr_array :parameters
  
  def initialize
    @path_to_command=''
    @parameters = []
    super()
  end
    
  def execute
    result = run_command "Exec", @parameters.join(" ")
    
    failure_message = 'Exec Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
end
