require 'albacore/support/albacore_helper'

module NCover
	class CodeCoverageBase
		include YAMLConfig
		
		attr_accessor :coverage_type, :minimum, :item_type 
		
		def initialize(coverage_type, params={})
			super()
			@coverage_type = coverage_type
			@minimum = 0
			@item_type = :View
			parse_config(params) unless params.nil?
		end
		
		def get_coverage_options
			options = "#{@coverage_type}"
			options << ":#{@minimum}" unless @minimum.nil?
			options << ":#{@item_type}" unless @item_type.nil?
			options
		end
	end
end	
	