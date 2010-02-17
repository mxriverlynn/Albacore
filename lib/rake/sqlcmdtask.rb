require 'rake/tasklib'

def sqlcmd(name=:sqlcmd, *args, &block)
  Albacore::SQLCmdTask.new(name, *args, &block)
end
  
module Albacore  
  class SQLCmdTask < Albacore::AlbacoreTask
    def execute(name)
      sqlcmd = SQLCmd.new
      sqlcmd.load_config_by_task_name(name)
      call_task_block(sqlcmd)
      sqlcmd.run
      fail if sqlcmd.failed
    end  
  end
end