class AssemblyInfo
	
	attr_accessor :version, :title
	
	def write(assemblyinfo_file)
		File.open(assemblyinfo_file, 'w') do |f|
			
			f.write using_statements
			f.write "\n"
			f.write build_attribute("AssemblyVersion", @version) if :version != nil
			f.write build_attribute("AssemblyTitle", @title) if :title != nil			
		end
	end
	
	def using_statements
		statements = ''
		statements << "using System.Reflection;\n"
		statements << "using System.Runtime.InteropServices;\n"
		statements
	end
	
	def build_attribute(attr_name, attr_data)
		attribute = "[assembly: #{attr_name}(\"#{attr_data}\")]"
		attribute
	end
	
end