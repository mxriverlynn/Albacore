class AssemblyInfoTester
	
	attr_accessor :version, :assemblyinfo_file, :title
	
	def initialize
		@version = "0.0.0.1"
		@assemblyinfo_file = File.join(File.dirname(__FILE__), "AssemblyInfo", "AssemblyInfo.cs")
		@title = "some assembly title"
	end
	
	def read_assemblyinfo_file
		contents = ''
		File.open(@assemblyinfo_file, "r") do |f|
    		contents = f.read
		end
		contents		
	end
	
end