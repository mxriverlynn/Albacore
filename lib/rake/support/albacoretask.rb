module Albacore
	class AlbacoreTask < ::Rake::TaskLib
		attr_accessor :name
		
		def initialize(name, *args, &block)
			@block = block
			@args = args.insert(0, name)
			define
		end
		
		def define
			task *@args do |task, task_args|
				execute task_args
			end
		end
	end
end