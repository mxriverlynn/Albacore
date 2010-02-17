require 'rake/tasklib'
require 'albacore'

def plink(name=:command, *args, &block)
  Albacore::PLinkTask.new(name, *args, &block)
end

module Albacore  
  class PLinkTask < Albacore::AlbacoreTask
    attr_accessor :remote_parameters, :remote_path_to_command

    def execute(name)
      cmd = PLink.new()
      cmd.load_config_by_task_name(name)
      call_task_block(cmd)
      cmd.run
      fail if cmd.failed
    end  
  end
end



