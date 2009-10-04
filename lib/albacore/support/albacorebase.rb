require File.join(File.dirname(__FILE__), 'logging')

module AlbacoreBase
	include LogBase
	
	attr_accessor :failed
	
	def initialize
		@failed = false
		super()
	end
	
	def fail
		@failed = true
	end
	
end