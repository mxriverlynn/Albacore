require 'rake/tasklib'

def nunit(name=:nunit, *args, &block)
  Albacore::NUnitTask.new(name, *args, &block)
end
  
module Albacore
  class NUnitTask < Albacore::AlbacoreTask
    def execute(name)
      nunit = NUnitTestRunner.new
      nunit.load_config_by_task_name(name)
      call_task_block(nunit)
      nunit.execute
      fail if nunit.failed
    end    
  end
end
