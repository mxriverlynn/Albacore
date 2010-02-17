require 'rake/tasklib'

def expandtemplates(name=:expandtemplates, *args, &block)
  Albacore::ExpandTemplatesTask.new(name, *args, &block)
end
  
module Albacore  
  class ExpandTemplatesTask < Albacore::AlbacoreTask
    def execute(name)
      exp = ExpandTemplates.new
      exp.load_config_by_task_name(name)
      call_task_block(exp)
      exp.expand
    end  
  end
end