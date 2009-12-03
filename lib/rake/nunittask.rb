require 'rake/tasklib'

def nunittask(name=:nunit, *args, &block)
	Albacore::NUnitTask.new(name, *args, &block)
end
	
module Albacore
	class NUnitTask < Albacore::AlbacoreTask
		def execute(task_args)
			@nunit = NUnitTestRunner.new
			@block.call(@nunit, *task_args) unless @block.nil?
			@nunit.execute
			fail if @nunit.failed
		end		
	end
end
