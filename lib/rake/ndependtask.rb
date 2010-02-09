require 'rake/tasklib'
require 'albacore'

def ndepend(name=:command, *args, &block)
  Albacore::NDepend.new(name, *args, &block)
end

module Albacore
  class NDependTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      cmd = NDepend.new()
      cmd.load_config_by_task_name(name)
      @block.call(cmd, *task_args) unless @block.nil?
      cmd.run
      fail if cmd.failed
    end
  end
end



