require 'rake/tasklib'

module Albacore
	def self.msbuild(name=:msbuild, *args, &block)
		MSBuildTask.new(name, *args, &block)
	end
	
	class MSBuildTask < Albacore::AlbacoreTask		
		def execute(task_args)
			@msbuild = MSBuild.new
			@block.call(@msbuild, *task_args) unless @block.nil? 
			@msbuild.build
			fail if @msbuild.failed
		end		
	end
	
end
