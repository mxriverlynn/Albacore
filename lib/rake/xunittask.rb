require 'rake/tasklib'

def xunit(name=:xunit, *args, &block)
  Albacore::XUnitTask.new(name, *args, &block)
end
  
module Albacore
  class XUnitTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @xunit = XUnitTestRunner.new
      @xunit.load_config_by_task_name(name)
      @block.call(@xunit, task_args) unless @block.nil?
      @xunit.execute
      fail if @xunit.failed
    end
  end
end