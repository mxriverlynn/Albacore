require 'logging'

class MSpecTestRunner
	include LogBase
	
	attr_accessor :assemblies, :path_to_exe, :html_output
	
	def initialize(path_to_exe)
		@path_to_exe = path_to_exe
		@assemblies=[]
		super()
	end
	
	def get_command_line
		command = []
		command << @path_to_exe
		command << build_assembly_list unless @assemblies.empty?
		command << build_html_output unless @html_output.nil?
		
		cmdline = command.join(" ")
		@logger.debug "Build MSpec Test Runner Command Line: " + cmdline
		cmdline
	end
	
	def build_assembly_list
		@assembly.join(" ") 
	end
	
	def build_html_output
		"--html #{@html_output}"
	end
end