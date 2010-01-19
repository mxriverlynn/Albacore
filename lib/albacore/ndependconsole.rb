require "albacore/support/albacore_helper"
class NDependConsole
  include RunCommand
  include Logging

  attr_accessor :path_to_command, :project_file , :parameters
  def initialize()
    super()
    @parameters =[]
    @require_valid_command = true
  end
  def run
    check_comand
    return if @failed
    params = []
    params << @project_file
    params << @parameters.join(" ")
    run_command @path_to_command, params.join(" ")
  end

  def check_comand
    return if @project_file
    fail_with_message 'A ndepend project file is required'
  end

end