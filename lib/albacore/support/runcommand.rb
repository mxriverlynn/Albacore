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
  
  def run_command(name="Command Line", parameters=nil)
    params = Array.new(@parameters)
    params << parameters unless parameters.nil?
    
    command = get_command(params)
    @logger.debug "Executing #{name}: #{command}"
    
    set_working_directory
    result = system command
    reset_working_directory
    
    result
  end

  def get_command(params)
    if Albacore.configuration.has_command? @command
      command = Albacore.configuration.get_command @command 
    else
      command = @command
    end
    command = "\"#{command}\""
    command +=" #{params.join(' ')}" if params.count > 0
    command
  end

  def combine_parameters(params1, params2)
    combined = params1.collect
    combined = combined.push(params2) unless params2.nil?
    combined
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
