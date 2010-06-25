require 'albacore/support/attrmethods'

module RunCommand
  extend AttrMethods
  
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
    
    cmd = get_command(params)
    @logger.debug "Executing #{name}: #{cmd}"
    
    set_working_directory
    result = system cmd
    reset_working_directory
    
    result
  end

  def get_command(params)
    cmd = "\"#{@command}\""
    cmd +=" #{params.join(' ')}" if params.length > 0
    cmd
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
