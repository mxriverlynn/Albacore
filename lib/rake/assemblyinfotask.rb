require 'rake/tasklib'

def assemblyinfotask(name=:assemblyinfo, *args, &block)
	Albacore::AssemblyInfoTask.new(name, *args, &block)
end
	
module Albacore
	class AssemblyInfoTask < Albacore::AlbacoreTask
		def execute(task_args)
			@asm = AssemblyInfo.new
			@block.call(@asm, *task_args) unless @block.nil?
			@asm.write
			fail if @asm.failed
		end
	end
end
