class Docu
  attr_accessor :command_result, :command_parameters, :failed, :failure_message
  
  def run_command(command_name="Command Line", command_parameters="")
    @command_parameters = command_parameters
    @command_result || false
  end
  
  def fail_with_message(msg)
    @failed = true
    @failure_message = msg
  end
end