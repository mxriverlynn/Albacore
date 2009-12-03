require 'rake/tasklib'

module Albacore	
	def self.sqlcmd(name=:sqlcmd, *args, &block)
		SQLCmdTask.new(name, *args, &block)
	end
	
	class SQLCmdTask < Albacore::AlbacoreTask
		def execute(task_args)
			@sqlcmd = SQLCmd.new
			@block.call(@sqlcmd, *task_args) unless @block.nil?
			@sqlcmd.run
			fail if @sqlcmd.failed
		end	
	end
end