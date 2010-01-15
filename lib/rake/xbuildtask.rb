require 'rake/tasklib'

def xbuild(name=:xbuild, *args, &block)
  Albacore::XBuildTask.new(name, *args, &block)
end

def mono(name=:mono, *args, &block)
  Albacore::XBuildTask.new(name, *args, &block)
end
    
module Albacore
  class XBuildTask < Albacore::AlbacoreTask    
    def execute(name, task_args)
      @xbuild = XBuild.new
      @xbuild.load_config_by_task_name(name)
      @block.call(@xbuild, *task_args) unless @block.nil? 
      @xbuild.build
      fail if @xbuild.failed
    end    
  end
  
end
