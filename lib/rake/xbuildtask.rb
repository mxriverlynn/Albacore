require 'rake/tasklib'

def xbuild(name=:xbuild, *args, &block)
  Albacore::XBuildTask.new(name, *args, &block)
end

def mono(name=:mono, *args, &block)
  Albacore::XBuildTask.new(name, *args, &block)
end
    
module Albacore
  class XBuildTask < Albacore::AlbacoreTask    
    def execute(name)
      xbuild = XBuild.new
      xbuild.load_config_by_task_name(name)
      call_task_block(xbuild)
      xbuild.build
      fail if xbuild.failed
    end    
  end
  
end
