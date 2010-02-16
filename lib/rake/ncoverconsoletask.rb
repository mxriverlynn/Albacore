require 'rake/tasklib'

def ncoverconsole(name=:ncoverconsole, *args, &block)
  Albacore::NCoverConsoleTask.new(name, *args, &block)
end
  
module Albacore
  class NCoverConsoleTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @ncover = NCoverConsole.new
      @ncover.load_config_by_task_name(name)
      @block.call(@ncover, task_args) unless @block.nil?
      @ncover.run
      fail if @ncover.failed
    end  
  end
end
