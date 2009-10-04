require File.join(File.dirname(__FILE__), 'patches', 'buildparameters')
require File.join(File.dirname(__FILE__), 'support', 'albacorebase')

class MSBuild
	include AlbacoreBase
	
	attr_accessor :path_to_exe, :solution, :verbosity
	
	def initialize(path_to_exe=nil)
		if path_to_exe == nil
			build_path_to_exe
		else
			@path_to_exe = path_to_exe
		end	
		super()
	end
	
	def build_path_to_exe
		win_dir = ENV['windir'] || ENV['WINDIR']
		@path_to_exe = File.join(win_dir.dup, 'Microsoft.NET', 'Framework', 'v3.5', 'MSBuild.exe')
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
		check_msbuild @path_to_exe
		check_solution solution
		return false if @failed
		
		cmd = "\"#{@path_to_exe}\" \"#{solution}\""
		cmd << " /verbosity:#{@verbosity}" if @verbosity != nil
		cmd << " /property:#{@properties.build_parameters}" if @properties != nil
		cmd << " /target:#{@targets.build_parameters}" if @targets != nil
		
		@logger.debug "Executing MSBuild: " + cmd
		system cmd
	end
	
	def check_solution(file)
		return if file
		msg = 'solution cannot be nil'
		@logger.fatal msg
		fail
	end

	def check_msbuild(file)
		return if File.exist?(file)
		msg = 'invalid path to msbuild.exe - file not found: ' + File.expand_path(file)
		@logger.fatal msg
		fail
	end	
end
