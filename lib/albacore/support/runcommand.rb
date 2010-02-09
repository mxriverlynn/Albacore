require 'albacore/support/failure'

module RunCommand
  extend AttrMethods
  include Failure
  
  attr_accessor :path_to_command, :require_valid_command, :command_directory
  attr_array :parameters
  
  def initialize
    @require_valid_command = true
    @command_directory = Dir.pwd
    @parameters = []
    super()
  end
  
  def run_command(command_name="Command Line", command_parameters="")
    if @require_valid_command
      return false unless valid_command_exists
    end

    command_parameters = command_parameters + "#{@parameters.join(' ')}"
    
    command = "\"#{@path_to_command}\" #{command_parameters}"
    @logger.debug "Executing #{command_name}: #{command}"
    
    set_working_directory    
    result = system command
    reset_working_directory
    
    result
  end
  
  def valid_command_exists
    return true if File.exist?(@path_to_command || "")
    msg = "Command not found: #{@path_to_command}"
    @logger.fatal msg
  end
  
  def set_working_directory
    @original_directory = Dir.pwd
    return if @command_directory == @original_directory
    Dir.chdir(@command_directory)
  end
  
  def reset_working_directory
    return if Dir.pwd == @original_directory
    Dir.chdir(@original_directory)
  end
end