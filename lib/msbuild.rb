class MSBuild
	attr_accessor :path_to_exe
	
	def initialize(path_to_exe = "") 
		build_path_to_exe if path_to_exe == ""
	end
	
	def build_path_to_exe
		@path_to_exe = File.join(ENV['windir'].dup, 'Microsoft.NET', 'Framework', 'v3.5', 'MSBuild.exe')
	end
	
	def build(solution, options={})
		
		option_text = ''
		options.each do |key, value|
			option_text << "/p:#{key}\=#{value} "
		end
		
		cmd = "\"#{@path_to_exe}\" \"#{solution}\" #{option_text}"
		
		system cmd
	end
	
end