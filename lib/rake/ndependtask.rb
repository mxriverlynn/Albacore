require 'rake/tasklib'
require 'albacore'

def ndepend(name=:command, *args, &block)
  Albacore::NDepend.new(name, *args, &block)
end

module Albacore
  class NDependTask < Albacore::AlbacoreTask
    def execute(name)
      cmd = NDepend.new()
      cmd.load_config_by_task_name(name)
      call_task_block(cmd)
      cmd.run
      fail if cmd.failed
    end
  end
end



