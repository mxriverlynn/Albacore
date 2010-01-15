require 'rake/tasklib'

def docu(name=:docu, *args, &block)
  Albacore::DocuTask.new(name, *args, &block)
end

module Albacore
  class DocuTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @docu = Docu.new
      @docu.load_config_by_task_name(name)
      @block.call(@docu, *task_args) unless @block.nil?
      @docu.execute
      fail if @docu.failed
    end
  end
end