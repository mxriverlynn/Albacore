require File.join(File.dirname(__FILE__), '../', 'support', 'albacore_helper')

module NCover
	module Reports
	
		class SymbolCoverage
			include YAMLConfig
			
			attr_accessor :minimum, :item_type 
			
			def initialize(params={})
				super()
				@minimum = 0
				@item_type = :View
				parse_config(params) unless params.nil?
			end
			
			def get_coverage_options
				options = "SymbolCoverage"
				options << ":#{minimum}" unless minimum.nil?
				options << ":#{item_type}" unless item_type.nil?
				options
			end
		end
		
	end
end