require 'rake/tasklib'

module Albacore
	def self.assemblyinfo(name=:assemblyinfo, *args, &block)
		AssemblyInfoTask.new(name, *args, &block)
	end
	
	class AssemblyInfoTask < Albacore::AlbacoreTask
		def execute(task_args)
			@asm = AssemblyInfo.new
			@block.call(@asm, *task_args) unless @block.nil?
			@asm.write
			fail if @asm.failed
		end
	end
end
