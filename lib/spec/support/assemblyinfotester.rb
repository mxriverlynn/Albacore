class AssemblyInfoTester
	
	attr_accessor :version, :assemblyinfo_file, :title, :description
	
	def initialize
		@version = "0.0.0.1"
		@title = "some assembly title"
		@description = "some assembly description goes here."
		
		setup_assemblyinfo_file
	end
	
	def setup_assemblyinfo_file
		@assemblyinfo_file = File.join(File.dirname(__FILE__), "AssemblyInfo", "AssemblyInfo.cs")
		File.delete @assemblyinfo_file if File.exist? @assemblyinfo_file
	end
	
	def read_assemblyinfo_file
		contents = ''
		File.open(@assemblyinfo_file, "r") do |f|
    		contents = f.read
		end
		contents		
	end
	
end