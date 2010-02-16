require 'rake/tasklib'

def sqlcmd(name=:sqlcmd, *args, &block)
  Albacore::SQLCmdTask.new(name, *args, &block)
end
  
module Albacore  
  class SQLCmdTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @sqlcmd = SQLCmd.new
      @sqlcmd.load_config_by_task_name(name)
      @block.call(@sqlcmd, task_args) unless @block.nil?
      @sqlcmd.run
      fail if @sqlcmd.failed
    end  
  end
end