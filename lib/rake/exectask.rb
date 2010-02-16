require 'rake/tasklib'

def exec(name=:exec, *args, &block)
  Albacore::ExecTask.new(name, *args, &block)
end
  
module Albacore
  class ExecTask < Albacore::AlbacoreTask    
    def execute(name, task_args)
      @exec = Exec.new
      @exec.load_config_by_task_name(name)
      @block.call(@exec, task_args) unless @block.nil? 
      @exec.execute
      fail if @exec.failed
    end    
  end
  
end
