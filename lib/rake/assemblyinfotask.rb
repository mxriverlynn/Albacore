require 'rake/tasklib'

def assemblyinfo(name=:assemblyinfo, *args, &block)
  Albacore::AssemblyInfoTask.new(name, *args, &block)
end
  
module Albacore
  class AssemblyInfoTask < Albacore::AlbacoreTask
    def execute(name)
      @asm = AssemblyInfo.new
      @asm.load_config_by_task_name(name)
      call_task_block
      @asm.write
      fail if @asm.failed
    end
  end
end
