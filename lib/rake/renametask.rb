require 'rake/tasklib'

module Albacore
	def self.rename(name=:rename, *args, &block)
		RenameTask.new(name, *args, &block)
	end
	
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
