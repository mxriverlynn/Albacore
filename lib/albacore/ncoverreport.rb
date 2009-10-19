require File.join(File.dirname(__FILE__), 'support', 'albacore_helper')

class NCoverReport
	include RunCommand
	include YAMLConfig
	
	def initialize
		super()
	end
	
end