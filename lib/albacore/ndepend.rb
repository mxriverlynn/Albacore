require "albacore/support/albacore_helper"
class NDepend
  extend AttrMethods
  include RunCommand
  include Logging
  include YAMLConfig

  attr_accessor :path_to_command, :project_file
  def initialize()
    super()
  end
  
  def run
    return unless check_comand
    result = run_command @path_to_command, create_parameters.join(" ")
    failure_message = 'Command Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end

  def create_parameters
    params = []
    params << File.expand_path(@project_file)
    return params
  end

  def check_comand
    return true if @project_file
    fail_with_message 'A ndepend project file is required'
    return false
  end

end