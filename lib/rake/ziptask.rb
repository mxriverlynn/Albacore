require 'rake/tasklib'

module Albacore
	def self.zip(name=:zip, *args, &block)
		ZipTask.new(name, *args, &block)
	end
	
	class ZipTask < Albacore::AlbacoreTask
		def execute(task_args)
			@zip = ZipDirectory.new
			@block.call(@zip, *task_args) unless @block.nil?
			@zip.package
			fail if @zip.failed
		end		
	end
end