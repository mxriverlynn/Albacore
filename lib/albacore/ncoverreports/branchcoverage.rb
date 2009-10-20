require File.join(File.dirname(__FILE__), 'codecoveragebase')

module NCover
	class BranchCoverage < NCover::CodeCoverageBase
		def initialize(params={})
			super("BranchCoverage", params)
		end		
	end
end	
	