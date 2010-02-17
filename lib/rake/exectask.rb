require 'rake/tasklib'

def exec(name=:exec, *args, &block)
  Albacore::ExecTask.new(name, *args, &block)
end
  
module Albacore
  class ExecTask < Albacore::AlbacoreTask    
    def execute(name)
      exec = Exec.new
      exec.load_config_by_task_name(name)
      call_task_block(exec)
      exec.execute
      fail if exec.failed
    end    
  end
  
end
