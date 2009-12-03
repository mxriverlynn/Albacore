require 'rake/tasklib'

def xunittask(name=:xunit, *args, &block)
	Albacore::XUnitTask.new(name, *args, &block)
end
	
module Albacore
	class XUnitTask < Albacore::AlbacoreTask
		def execute(task_args)
			@xunit = XUnitTestRunner.new
		  	@block.call(@xunit, *task_args) unless @block.nil?
			@xunit.execute
			fail if @xunit.failed
		end
	end
end