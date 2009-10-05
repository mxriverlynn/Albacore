require File.join(File.dirname(__FILE__), 'logging')

module ModelBase
	include LogBase
	
	attr_accessor :failed
	
	def initialize
		@failed = false
		super()
	end
	
	def fail
		@failed = true
	end
	
	def fail_with_message(msg)
		@logger.fatal msg
		fail
	end
end

