require File.join(File.dirname(__FILE__), 'reportfilterbase')

module NCover
	class AssemblyFilter < NCover::ReportFilterBase
		def initialize(params={})
			super("Assembly", params)
		end		
	end
end	
	