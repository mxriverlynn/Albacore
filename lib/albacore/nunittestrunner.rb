require 'albacore/support/albacore_helper'

class NUnitTestRunner
	include RunCommand
	include YAMLConfig
	
	attr_accessor :path_to_command, :assemblies, :options
	
	def initialize(path_to_command='')
		super()
		@path_to_command = path_to_command
		@options=[]
		@assemblies=[]
	end
	
	def get_command_line
		command_params = []
		command_params << @path_to_command
		command_params << get_command_parameters
		commandline = command_params.join(" ")
		@logger.debug "Build NUnit Test Runner Command Line: " + commandline
		commandline
	end
	
	def get_command_parameters
		command_params = []
		command_params << @assemblies.join(" ") unless @assemblies.nil?
		command_params << @options.join(" ") unless @options.nil?
		command_params
	end
	
	def execute()
		command_params = get_command_parameters
		result = run_command "NUnit", command_params.join(" ")
		
		failure_message = 'NUnit Failed. See Build Log For Detail'
		fail_with_message failure_message if !result
	end	
end