require 'rake/tasklib'

def assemblyinfo(name=:assemblyinfo, *args, &block)
  Albacore::AssemblyInfoTask.new(name, *args, &block)
end
  
module Albacore
  class AssemblyInfoTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @asm = AssemblyInfo.new
      @asm.load_config_by_task_name(self.class.to_s.downcase)
      @block.call(@asm, *task_args) unless @block.nil?
      @asm.write
      fail if @asm.failed
    end
  end
end
