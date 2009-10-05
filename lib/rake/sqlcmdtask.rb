require 'rake/tasklib'

module Rake	
	class SQLCmdTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:MSBuild)
			@name = name
			@sqlcmd = SQLCmd.new
			yield @sqlcmd if block_given?
			define
		end
		
		def define
			task name do
				@sqlcmd.run
				fail if @sqlcmd.failed
			end
		end	
	end
end