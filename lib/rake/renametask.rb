require 'rake/tasklib'

def renametask(name=:rename, *args, &block)
	Albacore::RenameTask.new(name, *args, &block)
end
	
module Albacore
	class RenameTask < Albacore::AlbacoreTask
		attr_accessor :actual_name, :target_name
		
		def execute(task_args)
			@block.call(self, *task_args) unless @block.nil?
			if (@actual_name.nil? || @target_name.nil?)
				fail
			else
				File.rename(@actual_name, @target_name)
			end
		end
	end
end
