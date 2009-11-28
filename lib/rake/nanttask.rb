require 'rake/tasklib'

module Albacore
	class NAntTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:nant, &block)
			@name = name
			@nant = NAnt.new
			@block = block
			define
		end
		
		def define
			task name do
				@block.call(@nant) unless @block.nil?
				#@nant.run
				fail if @nant.failed
			end
		end		
	end
end
