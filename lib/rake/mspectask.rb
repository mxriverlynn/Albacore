require 'rake/tasklib'

def mspec(name=:mspec, *args, &block)
  Albacore::MSpecTask.new(name, *args, &block)
end
  
module Albacore
  class MSpecTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @mspec = MSpecTestRunner.new
      @mspec.load_config_by_task_name(name)
      @block.call(@mspec, *task_args) unless @block.nil?
      @mspec.execute
      fail if @mspec.failed
    end    
  end
end