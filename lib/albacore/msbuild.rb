require File.join(File.dirname(__FILE__), 'patches', 'buildparameters')
require File.join(File.dirname(__FILE__), 'support', 'logging')

class MSBuild
	include LogBase
	
	attr_accessor :path_to_exe, :solution
	
	def initialize(path_to_exe=nil)
		if path_to_exe == nil
			build_path_to_exe
		else
			@path_to_exe = path_to_exe
		end	
		super()
	end
	
	def build_path_to_exe
		@path_to_exe = File.join(ENV['windir'].dup, 'Microsoft.NET', 'Framework', 'v3.5', 'MSBuild.exe')
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
		cmd = "\"#{@path_to_exe}\" \"#{solution}\""
		cmd << " /property:#{@properties.build_parameters}" if @properties != nil
		cmd << " /target:#{@targets.build_parameters}" if @targets != nil
		
		@logger.debug "Executing MSBuild: " + cmd
		system cmd
	end
	
end
