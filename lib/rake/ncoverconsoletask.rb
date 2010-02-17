require 'rake/tasklib'

def ncoverconsole(name=:ncoverconsole, *args, &block)
  Albacore::NCoverConsoleTask.new(name, *args, &block)
end
  
module Albacore
  class NCoverConsoleTask < Albacore::AlbacoreTask
    def execute(name)
      ncover = NCoverConsole.new
      ncover.load_config_by_task_name(name)
      call_task_block(ncover)
      ncover.run
      fail if ncover.failed
    end  
  end
end
