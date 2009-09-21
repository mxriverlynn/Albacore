require 'patches/buildparameters'

class MSBuild
	attr_accessor :path_to_exe
	
	def initialize(path_to_exe=nil) 
		@properties={}
		@targets={}

		if path_to_exe == nil
			build_path_to_exe
		else
			@path_to_exe = path_to_exe
		end		
	end
	
	def build_path_to_exe
		@path_to_exe = File.join(ENV['windir'].dup, 'Microsoft.NET', 'Framework', 'v3.5', 'MSBuild.exe')
	end
	
	def targets=(targets={})
		@targets=targets
	end
	
	def properties=(properties={})
		@properties = properties
	end
	
	def build(solution)
		cmd = "\"#{@path_to_exe}\" \"#{solution}\""
		cmd << " /property:#{@properties.build_parameters}" if @properties.length>0
		cmd << " /target:#{@targets.build_parameters}" if @targets.length>0
		
		system cmd
	end
	
end
