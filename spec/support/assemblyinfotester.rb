require 'albacore/assemblyinfo'

class AssemblyInfoTester < AssemblyInfo
	
	attr_accessor :assemblyinfo_file
	
	def initialize
		@version = "0.0.0.1"
		@title = "some assembly title"
		@description = "some assembly description goes here."
		@copyright = "some copyright info goes here"
		@com_visible = false
		@com_guid = "dbabb27c-a536-4b5b-91f1-2226b6e3655c"
		@company_name = "some company name"
		@product_name = "my product, yo."
		@file_version = "1.0.0.0"
		@trademark = "some trademark info goes here"
		
		setup_assemblyinfo_file
	end
	
	def setup_assemblyinfo_file
		@assemblyinfo_file = File.join(File.dirname(__FILE__), "AssemblyInfo", "AssemblyInfo.cs")
		File.delete @assemblyinfo_file if File.exist? @assemblyinfo_file
	end
	
	def build_and_read_assemblyinfo_file(assemblyinfo)
		assemblyinfo.output_file = @assemblyinfo_file
		assemblyinfo.write

		contents = ''
		File.open(@assemblyinfo_file, "r") do |f|
    		contents = f.read
		end
		contents		
	end
	
	def yaml_file
		return File.join(File.dirname(__FILE__), "AssemblyInfo", "assemblyinfo.yml")
	end
	
end