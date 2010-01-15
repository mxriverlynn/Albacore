require 'rake/tasklib'

def unzip(name=:unzip, *args, &block)
  Albacore::UnZipTask.new(name, *args, &block)
end
  
module Albacore
  class UnZipTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @zip = Unzip.new
      @zip.load_config_by_task_name(name)
      @block.call(@zip, *task_args) unless @block.nil?
      @zip.unzip
      fail if @zip.failed
    end    
  end
end