require 'rake/tasklib'

module Albacore
	def self.nunit(name=:nunit, *args, &block)
		NUnitTask.new(name, *args, &block)
	end
	
	class NUnitTask < Albacore::AlbacoreTask
		def execute(task_args)
			@nunit = NUnitTestRunner.new
			@block.call(@nunit, *task_args) unless @block.nil?
			@nunit.execute
			fail if @nunit.failed
		end		
	end
end
