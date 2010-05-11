require 'albacore/support/failure'
require 'albacore/support/attrmethods.rb'

module RunCommand
  extend AttrMethods
  include Failure
  
  attr_accessor :command, :working_directory
  attr_array :parameters
  
  def initialize
    @working_directory = Dir.pwd
    @parameters = []
    super()
  end
  
  def run_command(command_name="Command Line", command_parameters=nil)
    combine_parameters = @parameters.collect
    combine_parameters.push(command_parameters) unless command_parameters.nil?
    
    command = "\"#{@command}\" #{combine_parameters.join(' ')}"
    @logger.debug "Executing #{command_name}: #{command}"
    
    set_working_directory    
    result = system command
    reset_working_directory
    
    result
  end
  
  def set_working_directory
    @original_directory = Dir.pwd
    return if @working_directory == @original_directory
    Dir.chdir(@working_directory)
  end
  
  def reset_working_directory
    return if Dir.pwd == @original_directory
    Dir.chdir(@original_directory)
  end
end
