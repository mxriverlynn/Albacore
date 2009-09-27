require 'logger'

module LogBase
	
	def initialize
		@logger = Logger.new(STDOUT)
		@logger.level = Logger::INFO
	end
	
	def logger
		@logger
	end
		
end