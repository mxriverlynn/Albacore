require File.join(File.dirname(__FILE__), 'support', 'logging')

class NCoverConsole
	include LogBase
	
	attr_accessor :path_to_exe, :output, :testrunner, :working_directory
	
	def initialize
		@output = {}
		@testrunner_args = []
		super()
	end
	
	def working_directory=(working_dir)
		@working_directory = "//working-directory " + working_dir
	end
	
	def run
		command = [
			@path_to_exe, 
			build_output_options(@output),
			@working_directory,
			@testrunner.get_command_line
		].join(" ")

		@logger.info "Executing Code Coverage Analysis."
		@logger.debug "NCover Command Line: " + command

		output = system command
	end
	
	def build_output_options(output)
		options = []
		output.each do |key, value|
			options << "//#{key} #{value}"
		end
		options.join(" ")
	end
end