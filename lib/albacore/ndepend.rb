require 'albacore/albacoremodel'
require 'albacore/config/ndependconfig'

class NDepend
  include AlbacoreModel
  include RunCommand
  include Configuration::NDepend

  attr_accessor :project_file

  def initialize()
    super()
    update_attributes ndepend.to_hash
  end
  
  def run
    return unless check_command
    result = run_command @command, create_parameters.join(" ")
    failure_message = 'Command Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end

  def create_parameters
    params = []
    params << File.expand_path(@project_file)
    return params
  end

  def check_command
    return true if @project_file
    fail_with_message 'A ndepend project file is required'
    return false
  end

end
