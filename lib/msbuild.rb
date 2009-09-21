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
		
		property_text = build_hash_options("property", @properties)
		target_text = build_array_options("target", @targets)
	
		cmd = "\"#{@path_to_exe}\" \"#{solution}\""
		cmd << " #{property_text}" if property_text != nil
		cmd << " #{target_text}" if target_text != nil
		
		system cmd
	end
	
	def build_hash_options(option_name, option_values={})
		return if (option_values.length==0)

		option_text = "/#{option_name}:"
		option_values.each do |key, value|
			option_text << "#{key}\=#{value};"
		end
		option_text = option_text.chop
		
		option_text
	end

	def build_array_options(option_name, option_values={})
		return if (option_values.length==0)

		option_text = "/#{option_name}:"
		option_values.each do |value|
			option_text << "#{value};"
		end
		option_text = option_text.chop
		
		option_text
	end
end
