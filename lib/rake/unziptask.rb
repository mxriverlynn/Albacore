require 'rake/tasklib'

def unzip(name=:unzip, *args, &block)
	Albacore::UnZipTask.new(name, *args, &block)
end
	
module Albacore
	class UnZipTask < Albacore::AlbacoreTask
		def execute(task_args)
			@zip = Unzip.new
			@block.call(@zip, *task_args) unless @block.nil?
			@zip.unzip
			fail if @zip.failed
		end		
	end
end