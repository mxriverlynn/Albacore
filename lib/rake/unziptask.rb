require 'rake/tasklib'

def unzip(name=:unzip, *args, &block)
  Albacore::UnZipTask.new(name, *args, &block)
end
  
module Albacore
  class UnZipTask < Albacore::AlbacoreTask
    def execute(name)
      zip = Unzip.new
      zip.load_config_by_task_name(name)
      call_task_block(zip)
      zip.unzip
      fail if zip.failed
    end    
  end
end