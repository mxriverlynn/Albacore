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
    params = Array.new
    params << parameters unless parameters.nil?
    params << @parameters unless (@parameters.nil? || @parameters.length==0)
    
    cmd = get_command(params)
    @logger.debug "Executing #{name}: #{cmd}"
    
    Dir.chdir(@working_directory) do
      return system cmd
    end
  end

  def get_command(params)
    executable = File.exists?(@command) ? File.expand_path(@command) : @command
    cmd = "\"#{executable}\""
    cmd +=" #{params.join(' ')}" if params.length > 0
    cmd
  end

  def combine_parameters(params1, params2)
    combined = params1.collect
    combined = combined.push(params2) unless params2.nil?
    combined
  end
end
