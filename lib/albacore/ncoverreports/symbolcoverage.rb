require File.join(File.dirname(__FILE__), '../', 'support', 'albacore_helper')

module NCover
	module Reports
	
		class SymbolCoverage
			include YAMLConfig
			
			attr_accessor :minimum, :coverage_level
			
			def initialize
				super()
				@coverage_type = :View
			end
			
			def coverage_metric
				:SymbolCoverage
			end
		end
		
	end
end