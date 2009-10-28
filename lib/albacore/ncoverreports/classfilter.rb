require File.join(File.dirname(__FILE__), 'reportfilterbase')

module NCover
	class ClassFilter < NCover::ReportFilterBase
		def initialize(params={})
			super("Class", params)
		end		
	end
end
