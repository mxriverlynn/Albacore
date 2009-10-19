require File.join(File.dirname(__FILE__), '../', 'support', 'albacore_helper')

module NCover
	module Reports
	
		class SymbolCoverage
			include YAMLConfig
			
			attr_accessor :value, :item_type 
			
			def initialize
				super()
				@value = 0
				@item_type = :View
			end
			
			def coverage_metric
				:SymbolCoverage
			end
		end
		
	end
end