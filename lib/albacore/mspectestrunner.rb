require 'logging'

class MSpecTestRunner
	include LogBase
	
	attr_accessor :assemblies, :path_to_command, :html_output
	
	def initialize(path_to_command)
		@path_to_command = path_to_command
		@assemblies=[]
		super()
	end
	
	def get_command_line
		command = []
		command << @path_to_command
		command << build_assembly_list unless @assemblies.empty?
		command << build_html_output unless @html_output.nil?
		
		cmdline = command.join(" ")
		@logger.debug "Build MSpec Test Runner Command Line: " + cmdline
		cmdline
	end
	
	def build_assembly_list
		@assemblies.map{|asm| "\"#{asm}\""}.join(" ") 
	end
	
	def build_html_output
		"--html #{@html_output}"
	end
end