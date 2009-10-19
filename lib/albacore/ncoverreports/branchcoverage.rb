require File.join(File.dirname(__FILE__), '../', 'support', 'albacore_helper')

module NCover
	module Reports
	
		class BranchCoverage
			include YAMLConfig
			
			attr_accessor :value, :item_type 
			
			def initialize(params={})
				super()
				@value = 0
				@item_type = :View
				parse_config(params) unless params.nil?
			end
			
			def coverage_metric
				:BranchCoverage
			end
		end
		
	end
end