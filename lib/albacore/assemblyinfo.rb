class AssemblyInfo
	
	attr_accessor :version, :title, :description, :file, :custom_attributes
	
	def write
		write_assemblyinfo @file
	end
	
	def write_assemblyinfo(assemblyinfo_file)
		File.open(assemblyinfo_file, 'w') do |f|			
			f.write using_statements + "\n"
			
			f.write build_attribute("AssemblyVersion", @version) if @version != nil
			f.write build_attribute("AssemblyTitle", @title) if @title != nil
			f.write build_attribute("AssemblyDescription", @description) if @description != nil
			
			write_custom_attributes(f) if @custom_attributes != nil
			
		end
	end
	
	def custom_attributes(attributes={})
		@custom_attributes = attributes
	end
	
	def using_statements
		statements = ''
		statements << "using System.Reflection;\n"
		statements << "using System.Runtime.InteropServices;\n"
		statements
	end
	
	def build_attribute(attr_name, attr_data)
		attribute = "[assembly: #{attr_name}(\"#{attr_data}\")]\n"
		attribute
	end
	
	def write_custom_attributes(f)
		@custom_attributes.each do |key, value|
			f.write build_attribute(key, value.to_s)
		end
	end
	
end