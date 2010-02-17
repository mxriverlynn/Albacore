require 'rake/tasklib'

def zip(name=:zip, *args, &block)
  Albacore::ZipTask.new(name, *args, &block)
end
  
module Albacore
  class ZipTask < Albacore::AlbacoreTask
    def execute(name)
      zip = ZipDirectory.new
      zip.load_config_by_task_name(name)
      call_task_block(zip)
      zip.package
      fail if zip.failed
    end    
  end
end