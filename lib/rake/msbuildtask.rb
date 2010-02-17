require 'rake/tasklib'

def msbuild(name=:msbuild, *args, &block)
  Albacore::MSBuildTask.new(name, *args, &block)
end
    
module Albacore
  class MSBuildTask < Albacore::AlbacoreTask    
    def execute(name)
      msbuild = MSBuild.new
      msbuild.load_config_by_task_name(name)
      call_task_block(msbuild)
      msbuild.build
      fail if msbuild.failed
    end    
  end
  
end
