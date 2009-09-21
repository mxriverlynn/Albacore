class MSBuildTestData
	
	attr_accessor :msbuild_path, :solution_path, :config_mode, :output_path
	
	def initialize(config_mode='Debug')
		@msbuild_path = "C:\\Windows/Microsoft.NET/Framework/v3.5/MSBuild.exe"
		@solution_path = File.join(File.dirname(__FILE__), "../", "support", "TestSolution", "TestSolution.sln")
		@config_mode = config_mode
		
		setup_output
	end
	
	def setup_output()
		@output_path = File.join(File.dirname(__FILE__), "../", "support", "TestSolution", "TestSolution", "bin", "#{@config_mode}", "TestSolution.dll")
		File.delete @output_path if File.exist? @output_path
	end
	
end

