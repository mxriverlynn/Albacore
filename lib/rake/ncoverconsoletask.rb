require 'rake/tasklib'

module Albacore
	class NCoverConsoleTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:ncoverconsole, &block)
			@name = name
			@block = block
			define
		end
		
		def define
			task name do
				@ncover = NCoverConsole.new
				@block.call(@ncover) unless @block.nil?
				@ncover.run
				fail if @ncover.failed
			end
		end	
	end
end
