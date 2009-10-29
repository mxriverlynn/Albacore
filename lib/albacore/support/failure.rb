require 'albacore/support/logging'

module Failure
	include Logging
	
	attr_accessor :failed
	
	def initialize
		super()
		@failed = false
	end
	
	def fail
		@failed = true
	end
	
	def fail_with_message(msg)
		@logger.fatal msg
		fail
	end
end

