require 'rake/tasklib'

module Albacore	
	class CommandTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:command, &block)
			@name = name
			@block = block
			define
		end
		
		def define
			task name do
				cmd = Command.new
				@block.call(cmd) unless @block.nil?
				cmd.execute
				fail if cmd.failed
			end
		end	
	end
end