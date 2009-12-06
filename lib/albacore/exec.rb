require 'albacore/support/albacore_helper'

class Exec
	include RunCommand
	include YAMLConfig
	include Logging
	
	attr_accessor :command, :parameters
	
	def initialize
		super()
	end
		
	def execute
		command_to_execute = []
		command_to_execute << "\"#{@command}\""
		command_to_execute << @parameters if parameters
		   
    begin
      system command_to_execute.join(" ")
    rescue 
      failure_message = "#{@command} Failed. See Build Log For Detail"
      raise failure_message
    end
	end
end
