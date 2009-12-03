require 'rake/tasklib'

module Albacore
	def self.xunit(name=:xunit, *args, &block)
		XUnitTask.new(name, *args, &block)
	end
	
	class XUnitTask < Albacore::AlbacoreTask
		def execute(task_args)
			@xunit = XUnitTestRunner.new
		  	@block.call(@xunit, *task_args) unless @block.nil?
			@xunit.execute
			fail if @xunit.failed
		end
	end
end