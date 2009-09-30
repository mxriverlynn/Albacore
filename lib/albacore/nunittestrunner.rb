require 'logging'

class NUnitTestRunner
	include LogBase
	
	attr_accessor :assemblies, :options, :path_to_exe
	
	def initialize(path_to_exe)
		@path_to_exe = path_to_exe
		@options=[]
		@assemblies=[]
		super()
	end
	
	def get_command_line
		command = [@path_to_exe, @assemblies.join(" "), @options.join(" ")].join(" ")
		@logger.debug "Build NUnit Test Runner Command Line: " + command
		command
	end
end