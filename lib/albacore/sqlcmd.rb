require 'yaml'

class SQLCmd
	#attr_accessor :path_to_exe, :server_name

	def configure(yml_file)
		puts yml_file.inspect + "..................."
		config = YAML::load(File.open(yml_file))
		puts config.inspect
		parse_config config
	end	
	
	def parse_config(config)
		config.each do |key, value|
			SQLCmd.send :attr_accessor, key
			send key+"=", value
		end
	end
	
end