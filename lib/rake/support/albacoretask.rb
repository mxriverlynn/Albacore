require 'rake/tasklib'

module Albacore
  class AlbacoreTask < ::Rake::TaskLib
    attr_accessor :name
    
    def initialize(name, *args, &block)
      @block = block
      args = args.insert(0, name)
      define name, args
    end
    
    def define(name, args)
      task *args do |task, task_args|
      	@task_args = task_args
        execute name.to_s
      end
    end
    
    def call_task_block(obj)
      if !@block.nil?
      	if @block.arity == 1
      	  @block.call(obj)
        else
      	  @block.call(obj, @task_args)
  	    end
  	  end
    end
  end
end