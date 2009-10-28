require File.join(File.dirname(__FILE__), 'reportfilterbase')

module NCover
	class MethodFilter < NCover::ReportFilterBase
		def initialize(params={})
			super("Method", params)
		end		
	end
end
