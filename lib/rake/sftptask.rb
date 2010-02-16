require 'rake/tasklib'

def sftp(name=:sftp, *args, &block)
  Albacore::SftpTask.new(name, *args, &block)
end
  
module Albacore
  class SftpTask < Albacore::AlbacoreTask
    def execute(name, task_args)
      @sftp = Sftp.new
      @sftp.load_config_by_task_name(name)
      @block.call(@sftp, task_args) unless @block.nil?
      @sftp.upload
    end
  end
end
