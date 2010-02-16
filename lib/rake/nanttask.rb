require 'rake/tasklib'

def nant(name=:nant, *args, &block)
  Albacore::NAntTask.new(name, *args, &block)
end

module Albacore
  class NAntTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      nant = NAnt.new
      nant.load_config_by_task_name(name)
      @block.call(nant, task_args) unless @block.nil? 
      nant.run
      fail if nant.failed
    end
  end
end
