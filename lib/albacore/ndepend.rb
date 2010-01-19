require "albacore/support/albacore_helper"
class NDepend
  include RunCommand
  include Logging
  include YAMLConfig

  attr_accessor :path_to_command, :project_file , :parameters
  def initialize()
    super()
    @parameters =[]
    @require_valid_command = true
  end
  
  def run
    check_comand
    return if @failed
    result = run_command @path_to_command, create_parameters
    failure_message = 'Command Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end

  def create_parameters
    params = []
    params << @project_file
    params << @parameters.join(" ")
    @logger.debug "NDependConsole Parameters" + @parameters.join(" ")
    return params
  end

  def check_comand
    return if @project_file
    fail_with_message 'A ndepend project file is required'
  end

end