require 'msbuild'

class MSBuildTestData
	
	attr_accessor :msbuild_path, :solution_path, :config_mode, :output_path
	
	def initialize(config_mode='Debug')
		@solution_path = File.join(File.dirname(__FILE__), "../", "support", "TestSolution", "TestSolution.sln")
		@msbuild_path = "C:\\Windows/Microsoft.NET/Framework/v3.5/MSBuild.exe"
		@config_mode = config_mode
		
		setup_output
	end
	
	def setup_output
		@output_path = File.join(File.dirname(__FILE__), "../", "support", "TestSolution", "TestSolution", "bin", "#{@config_mode}", "TestSolution.dll")
		File.delete @output_path if File.exist? @output_path
	end
	
	def msbuild(path_to_msbuild=nil)
		@msbuild = MSBuild.new path_to_msbuild
		@msbuild.extend(SystemPatch)
		@msbuild
	end
	
end