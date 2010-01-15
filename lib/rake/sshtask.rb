require 'rake/tasklib'

def ssh(name=:ssh, *args, &block)
  Albacore::SshTask.new(name, *args, &block)
end
  
module Albacore
  class SshTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @ssh = Ssh.new
      @ssh.load_config_by_task_name(name)
      @block.call(@ssh, *task_args) unless @block.nil?
      @ssh.execute
    end
  end
end
