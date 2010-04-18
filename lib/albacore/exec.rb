require 'albacore/support/albacore_helper'

class Exec
  include RunCommand
  include YAMLConfig
  include Logging
    
  def execute
    result = run_command "Exec"
    
    failure_message = 'Exec Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
end
