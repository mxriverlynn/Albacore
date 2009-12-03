require 'rake/tasklib'

def ziptask(name=:zip, *args, &block)
	Albacore::ZipTask.new(name, *args, &block)
end
	
module Albacore
	class ZipTask < Albacore::AlbacoreTask
		def execute(task_args)
			@zip = ZipDirectory.new
			@block.call(@zip, *task_args) unless @block.nil?
			@zip.package
			fail if @zip.failed
		end		
	end
end