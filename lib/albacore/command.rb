require 'albacore/support/albacore_helper'

class Command
	include RunCommand
	include YAMLConfig
	include Logging
	
	attr_accessor :parameters
	
	def initialize()
		super()
		@require_valid_command=false
		@path_to_command=''
		@parameters = []
	end
	
	def execute()
		result = run_command "Command", @parameters.join(" ")

		failure_message = 'Command Failed. See Build Log For Detail'
		fail_with_message failure_message if !result
	end
end
