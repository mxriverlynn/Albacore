require 'rake/tasklib'

def sqlcmdtask(name=:sqlcmd, *args, &block)
	Albacore::SQLCmdTask.new(name, *args, &block)
end
	
module Albacore	
	class SQLCmdTask < Albacore::AlbacoreTask
		def execute(task_args)
			@sqlcmd = SQLCmd.new
			@block.call(@sqlcmd, *task_args) unless @block.nil?
			@sqlcmd.run
			fail if @sqlcmd.failed
		end	
	end
end