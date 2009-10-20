require File.join(File.dirname(__FILE__), '../', 'support', 'albacore_helper')

module NCover
	class CodeCoverage
		include YAMLConfig
		
		attr_accessor :coverage_type, :minimum, :item_type 
		
		def initialize(params={})
			super()
			@coverage_type = :SymbolCoverage
			@minimum = 0
			@item_type = :View
			parse_config(params) unless params.nil?
		end
		
		def get_coverage_options
			options = @coverage_type.to_s
			options << ":#{minimum}" unless minimum.nil?
			options << ":#{item_type}" unless item_type.nil?
			options
		end
	end
end	
	