require 'rake/tasklib'

module Albacore	
	class SQLCmdTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:sqlcmd, &block)
			@name = name
			@block = block
			define
		end
		
		def define
			task name do
				@sqlcmd = SQLCmd.new
				@block.call(@sqlcmd) unless @block.nil?
				@sqlcmd.run
				fail if @sqlcmd.failed
			end
		end	
	end
end