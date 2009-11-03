require 'albacore/support/albacore_helper'
require 'yaml'

class ExpandTemplates
	include YAMLConfig
	include Logging
	
	attr_accessor :expand_files, :data_file
	
	def initialize
		super()
		@expand_files = []
	end
	
	def expand
		@expand_files.each { |template|
			if (template.instance_of? Hash)
				template.each{ |template_file, output_file| 
					expand_template template_file, output_file
				}
			else
				expand_template template, template
			end
		}
	end
	
private

	def expand_template(template_file, output_file)
		@logger.info "Parsing #{template_file} into #{output_file}"
		
		template_data = ''
		
		config = YAML::load(File.open(@data_file, "r"))
		File.open(template_file, "r") {|f| 
			template_data = f.read 
		}
		
		template_data.gsub!(/\#\{(.*?)\}/) {|match|
			value = config[$1.downcase]
			@logger.debug "Found \"\#{#{$1}}\": Replacing with \"#{value}\"."
			value
		}
		
		File.open(output_file, "w") {|output|
	    	output.write(template_data)
		}
	end
end