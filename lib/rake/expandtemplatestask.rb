require 'rake/tasklib'

module Albacore	
	def self.expandtemplates(name=:expandtemplates, *args, &block)
		ExpandTemplatesTask.new(name, *args, &block)
	end
	
	class ExpandTemplatesTask < Albacore::AlbacoreTask
		def execute(task_args)
			@exp = ExpandTemplates.new
			@block.call(@exp, *task_args) unless @block.nil?
			@exp.expand
		end	
	end
end