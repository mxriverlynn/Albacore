require File.join(File.dirname(__FILE__), 'support', 'logging')

class NCoverConsole
	include LogBase
	
	attr_accessor :path_to_exe, :coverage_type, :coverage_output, :testrunner, :working_directory
	
	def initialize
		@testrunner_args = []
		super()
	end
	
	def coverage(type, output)
		@coverage_type = "//#{type.to_s}"
		@coverage_output = output
	end
	
	def working_directory=(working_dir)
		@working_directory = "//working-directory " + working_dir
	end
	
	def run
		command = [
			@path_to_exe, 
			@coverage_type, 
			@coverage_output, 
			@working_directory,
			@testrunner.get_command_line
		].join(" ")

		@logger.info "Executing Code Coverage Analysis."
		@logger.debug "NCover Command Line: " + command

		output = system command
	end
end