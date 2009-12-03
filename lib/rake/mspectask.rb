require 'rake/tasklib'

def mspectask(name=:mspec, *args, &block)
	Albacore::MSpecTask.new(name, *args, &block)
end
	
module Albacore
	class MSpecTask < Albacore::AlbacoreTask
		def execute(task_args)
			@mspec = MSpecTestRunner.new
		  	@block.call(@mspec, *task_args) unless @block.nil?
			@mspec.execute
			fail if @mspec.failed
		end		
	end
end