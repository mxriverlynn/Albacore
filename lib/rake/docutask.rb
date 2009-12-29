require 'rake/tasklib'

def docu(name=:docu, *args, &block)
  Albacore::DocuTask.new(name, *args, &block)
end

module Albacore
  class DocuTask < Albacore::AlbacoreTask
    def execute(task_args)
      @docu = Docu.new
      @block.call(@docu, *task_args) unless @block.nil?
      @docu.execute
      fail if @docu.failed
    end
  end
end