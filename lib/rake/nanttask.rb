require 'rake/tasklib'

def nant(name=:nant, *args, &block)
  Albacore::NAntTask.new(name, *args, &block)
end

module Albacore
  class NAntTask < Albacore::AlbacoreTask
    def execute(task_args)
      nant = NAnt.new
      @block.call(nant, *task_args) unless @block.nil? 
      nant.run
      fail if nant.failed
    end
  end
end
