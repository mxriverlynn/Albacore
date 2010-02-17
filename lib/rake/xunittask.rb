require 'rake/tasklib'

def xunit(name=:xunit, *args, &block)
  Albacore::XUnitTask.new(name, *args, &block)
end
  
module Albacore
  class XUnitTask < Albacore::AlbacoreTask
    def execute(name)
      xunit = XUnitTestRunner.new
      xunit.load_config_by_task_name(name)
      call_task_block(xunit)
      xunit.execute
      fail if xunit.failed
    end
  end
end