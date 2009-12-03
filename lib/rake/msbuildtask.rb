require 'rake/tasklib'

def msbuildtask(name=:msbuild, *args, &block)
	Albacore::MSBuildTask.new(name, *args, &block)
end
	
module Albacore
	class MSBuildTask < Albacore::AlbacoreTask		
		def execute(task_args)
			@msbuild = MSBuild.new
			@block.call(@msbuild, *task_args) unless @block.nil? 
			@msbuild.build
			fail if @msbuild.failed
		end		
	end
	
end
