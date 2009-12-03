require 'rake/tasklib'

module Albacore
	def self.ncoverconsole(name=:ncoverconsole, *args, &block)
		NCoverConsoleTask.new(name, *args, &block)
	end
	
	class NCoverConsoleTask < Albacore::AlbacoreTask
		def execute(task_args)
			@ncover = NCoverConsole.new
			@block.call(@ncover, *task_args) unless @block.nil?
			@ncover.run
			fail if @ncover.failed
		end	
	end
end
