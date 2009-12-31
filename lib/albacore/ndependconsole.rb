require "albacore/support/albacore_helper"
class NDependConsole
  include RunCommand
  include Logging

	attr_accessor :path_to_command, :project_file
  def initialize()
    super()
    @require_valid_command = true
  end
	def run()
    check_comand
    return if @failed
	  run_command @path_to_command, @project_file
	end

  def check_comand
    return if @project_file
		fail_with_message 'A ndepend project file is required'
  end

end