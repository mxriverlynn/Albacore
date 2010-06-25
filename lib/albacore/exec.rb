require 'albacore/albacoremodel'

class Exec
  include AlbacoreModel
  include RunCommand
    
  def execute
    result = run_command "Exec"
    
    failure_message = 'Exec Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
end
