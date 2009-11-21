require 'albacore/support/albacore_helper'

class MSpecTestRunner
  include RunCommand
	include Logging
	include YAMLConfig
	
	attr_accessor :assemblies, :path_to_command, :html_output
	
	def initialize(path_to_command='')
		super()
		@path_to_command = path_to_command
		@assemblies=[]
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
	
	def execute()
		result = run_command "MSpec", get_command_line
		
		failure_message = 'MSpec Failed. See Build Log For Detail'
		fail_with_message failure_message if !result
	end
	
	def build_assembly_list
		@assemblies.map{|asm| "\"#{asm}\""}.join(" ") 
	end
	
	def build_html_output
		"--html #{@html_output}"
	end
end