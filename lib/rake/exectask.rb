require 'rake/tasklib'

def exec(name=:exec, *args, &block)
	Albacore::ExecTask.new(name, *args, &block)
end
	
module Albacore
	class ExecTask < Albacore::AlbacoreTask		
		def execute(task_args)
			@exec = Exec.new
			@block.call(@exec, *task_args) unless @block.nil? 
			@exec.execute
			fail if @exec.failed
		end		
	end
	
end
