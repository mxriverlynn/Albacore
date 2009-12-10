module SystemPatch
  attr_accessor :disable_system, :force_system_failure
  
  def initialize
    @disable_system = false
    @force_command_failure = false
  end
  
  def system_command
    @system_command
  end
  
  def system(cmd)
    @system_command = cmd
    result = true
    result = super(cmd) if !disable_system
    return false if @force_system_failure
    return result
  end
end
