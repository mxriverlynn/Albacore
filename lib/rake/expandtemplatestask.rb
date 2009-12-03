require 'rake/tasklib'

def expandtemplatestask(name=:expandtemplates, *args, &block)
	Albacore::ExpandTemplatesTask.new(name, *args, &block)
end
	
module Albacore	
	class ExpandTemplatesTask < Albacore::AlbacoreTask
		def execute(task_args)
			@exp = ExpandTemplates.new
			@block.call(@exp, *task_args) unless @block.nil?
			@exp.expand
		end	
	end
end