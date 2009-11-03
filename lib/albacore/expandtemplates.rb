require 'albacore/support/albacore_helper'
require 'yaml'

class ExpandTemplates
	include YAMLConfig
	
	attr_accessor :expand_files, :data_file
	
	def initialize
		super()
		@expand_files = []
	end
	
	def expand
		
	end
	
	def expand_template( template_file, output_file)
	
	  puts "Building #{output_file}"
	  template = File.open(template_file, "r")
	  output = File.open(output_file, "w")
	
	  template.each_line do |template_line|
	    template_line.gsub(/@([^@]+)@/) do |token|
	      value = @config[$1.downcase]
	      unless value.nil?
	        template_line = template_line.gsub(token, value.to_s)
	      end
	    end
	    output.write(template_line)
	  end
	  template.close
	  output.close
	
	end
end