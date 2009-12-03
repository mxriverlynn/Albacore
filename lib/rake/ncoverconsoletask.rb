require 'rake/tasklib'

def ncoverconsoletask(name=:ncoverconsole, *args, &block)
	Albacore::NCoverConsoleTask.new(name, *args, &block)
end
	
module Albacore
	class NCoverConsoleTask < Albacore::AlbacoreTask
		def execute(task_args)
			@ncover = NCoverConsole.new
			@block.call(@ncover, *task_args) unless @block.nil?
			@ncover.run
			fail if @ncover.failed
		end	
	end
end
