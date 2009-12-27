require 'rake/tasklib'
require 'albacore'

def plinkcommand(name=:command, *args, &block)
	Albacore::PLinkCommandTask.new(name, *args, &block)
end

module Albacore	
	class PLinkCommandTask < Albacore::AlbacoreTask
	  attr_accessor :remote_parameters, :remote_path_to_command

		def execute(task_args)
		  cmd = PLinkCommand.new()
			@block.call(cmd, *task_args) unless @block.nil?
			cmd.run
			fail if cmd.failed
		end	
	end
end



