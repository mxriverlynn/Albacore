require 'rake/tasklib'

module Albacore	
	def self.command(name=:command, *args, &block)
		CommandTask.new(name, *args, &block)
	end
	
	class CommandTask < Albacore::AlbacoreTask
		def execute(task_args)
			cmd = Command.new
			@block.call(cmd, *task_args) unless @block.nil?
			cmd.execute
			fail if cmd.failed
		end	
	end
end