require 'rake/tasklib'

def expandtemplates(name=:expandtemplates, *args, &block)
  Albacore::ExpandTemplatesTask.new(name, *args, &block)
end
  
module Albacore  
  class ExpandTemplatesTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @exp = ExpandTemplates.new
      @exp.load_config_by_task_name(name)
      @block.call(@exp, task_args) unless @block.nil?
      @exp.expand
    end  
  end
end