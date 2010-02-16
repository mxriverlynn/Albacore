require 'rake/tasklib'

def zip(name=:zip, *args, &block)
  Albacore::ZipTask.new(name, *args, &block)
end
  
module Albacore
  class ZipTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @zip = ZipDirectory.new
      @zip.load_config_by_task_name(name)
      @block.call(@zip, task_args) unless @block.nil?
      @zip.package
      fail if @zip.failed
    end    
  end
end