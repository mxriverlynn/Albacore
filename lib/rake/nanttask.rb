require 'rake/tasklib'

def nant(name=:nant, *args, &block)
  Albacore::NAntTask.new(name, *args, &block)
end

module Albacore
  class NAntTask < Albacore::AlbacoreTask
    def execute(name)
      nant = NAnt.new
      nant.load_config_by_task_name(name)
      call_task_block(nant)
      nant.run
      fail if nant.failed
    end
  end
end
