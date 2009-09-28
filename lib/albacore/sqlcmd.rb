require 'yaml'

class SQLCmd

	def configure(yml_file)
		config = YAML::load(File.open(yml_file))
		parse_config config
	end	
	
	def parse_config(config)
		config.each do |key, value|
			SQLCmd.send :attr_accessor, key
			send key+"=", value
		end
	end
	
end