require 'albacore/albacoretask'
require 'albacore/config/execconfig'

class Exec
  include AlbacoreTask
  include RunCommand
  include Configuration::Exec

  def initialize
    super()
    update_attributes exec.to_hash
  end
    
  def execute
    result = run_command "Exec"
    
    failure_message = 'Exec Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
end
