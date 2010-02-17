require 'rake/tasklib'

def ssh(name=:ssh, *args, &block)
  Albacore::SshTask.new(name, *args, &block)
end
  
module Albacore
  class SshTask < Albacore::AlbacoreTask
    def execute(name)
      ssh = Ssh.new
      ssh.load_config_by_task_name(name)
      call_task_block(ssh)
      ssh.execute
    end
  end
end
