require File.join(File.dirname(__FILE__), 'model')

module CommandBase
	include ModelBase
	
	attr_accessor :path_to_command, :require_valid_command
	
	def initialize
		super()
		@require_valid_command = true
	end
	
	def run_command(command_name="Command Line", command_parameters="")
		if @require_valid_command
			return false unless valid_command_exists
		end
		
		command = "\"#{@path_to_command}\" #{command_parameters}"
		@logger.debug "Executing #{command_name}: #{command}"
		
		system command		
	end
	
	def valid_command_exists
		return true if File.exist?(@path_to_command)
		msg = 'Command not found: ' + @path_to_command
		@logger.fatal msg
	end			
end