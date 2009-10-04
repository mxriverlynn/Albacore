require File.join(File.dirname(__FILE__), 'patches', 'buildparameters')
require File.join(File.dirname(__FILE__), 'support', 'albacorebase')

class MSBuild
	include CommandBase
	
	attr_accessor :solution, :verbosity
	
	def initialize
		@path_to_command = build_path_to_command
		super()
	end
	
	def build_path_to_command
		win_dir = ENV['windir'] || ENV['WINDIR']
		File.join(win_dir.dup, 'Microsoft.NET', 'Framework', 'v3.5', 'MSBuild.exe')
	end
	
	def targets(targets)
		@targets=targets
		@targets.extend(ArrayParameterBuilder)
	end
	
	def properties(properties)
		@properties = properties
		@properties.extend(HashParameterBuilder)
	end
	
	def build
		build_solution(@solution)
	end
	
	def build_solution(solution)
		check_solution solution
		
		command_parameters = " \"#{solution}\""
		command_parameters << " /verbosity:#{@verbosity}" if @verbosity != nil
		command_parameters << " /property:#{@properties.build_parameters}" if @properties != nil
		command_parameters << " /target:#{@targets.build_parameters}" if @targets != nil
		
		result = run_command "MSBuild", command_parameters
		
		failure_message = 'MSBuild Failed. See Build Log For Detail'
		fail_with_message failure_message if !result
	end
	
	def check_solution(file)
		if file.nil?
			msg = 'solution cannot be nil'
		else
			valid = File.exist?(file)
			(msg = 'solution Cannot Be Nil') if !valid
			return if valid
		end
		
		fail_with_message msg
	end
end
