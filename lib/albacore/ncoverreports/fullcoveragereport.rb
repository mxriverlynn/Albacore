require File.join(File.dirname(__FILE__), '../', 'support', 'albacore_helper')

module NCover
	module Reports
		
		class FullCoverageReport
			include YAMLConfig
			
			attr_accessor :output_path
			
			def initialize
				super()
			end
			
			def report_type
				:FullCoverageReport
			end
			
			def report_format
				:Html
			end
		end
		
	end
end