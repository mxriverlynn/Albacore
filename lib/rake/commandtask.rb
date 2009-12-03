require 'rake/tasklib'

def commandtask(name=:command, *args, &block)
	Albacore::CommandTask.new(name, *args, &block)
end
	
module Albacore	
	class CommandTask < Albacore::AlbacoreTask
		def execute(task_args)
			cmd = Command.new
			@block.call(cmd, *task_args) unless @block.nil?
			cmd.execute
			fail if cmd.failed
		end	
	end
end