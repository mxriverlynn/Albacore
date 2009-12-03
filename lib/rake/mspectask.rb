require 'rake/tasklib'

module Albacore
	def self.mspec(name=:mspec, *args, &block)
		MSpecTask.new(name, *args, &block)
	end
	
	class MSpecTask < Albacore::AlbacoreTask
		def execute(task_args)
			@mspec = MSpecTestRunner.new
		  	@block.call(@mspec, *task_args) unless @block.nil?
			@mspec.execute
			fail if @mspec.failed
		end		
	end
end