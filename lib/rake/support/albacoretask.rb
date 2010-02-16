require 'rake/tasklib'

module Albacore
  class AlbacoreTask < ::Rake::TaskLib
    attr_accessor :name
    
    def initialize(name, *args, &block)
      @block = block
      @args = args.insert(0, name)
      @name = name
      define
    end
    
    def define
      task *@args do |task, task_args|
      	puts "task: #{task.inspect}"
      	puts "@args: #{@args.inspect}"
      	puts "task args: #{task_args.inspect}"
        execute @name.to_s, task_args
      end
    end
  end
end