require 'rake/tasklib'

def xbuild(name=:xbuild, *args, &block)
	Albacore::XBuildTask.new(name, *args, &block)
end

def mono(name=:mono, *args, &block)
	Albacore::XBuildTask.new(name, *args, &block)
end
	  
module Albacore
	class XBuildTask < Albacore::AlbacoreTask		
		def execute(task_args)
			@xbuild = XBuild.new
			@block.call(@xbuild, *task_args) unless @block.nil? 
			@xbuild.build
			fail if @xbuild.failed
		end		
	end
	
end
