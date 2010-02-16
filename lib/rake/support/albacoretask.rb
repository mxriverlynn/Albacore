require 'rake/tasklib'

module Albacore
  class AlbacoreTask < ::Rake::TaskLib
    attr_accessor :name
    
    def initialize(name, *args, &block)
      @block = block
      args = args.insert(0, name)
      define(args)
    end
    
    def define(name, args)
      task *args do |task, task_args|
        execute name.to_s, task_args
      end
    end
    
    def call_task_block
      if !@block.nil?
      	if @block.arity == 1
      	  @block.call(@asm)
        else
      	  @block.call(@asm, task_args)
  	    end
  	  end
    end
  end
end