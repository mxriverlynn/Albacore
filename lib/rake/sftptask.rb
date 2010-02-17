require 'rake/tasklib'

def sftp(name=:sftp, *args, &block)
  Albacore::SftpTask.new(name, *args, &block)
end
  
module Albacore
  class SftpTask < Albacore::AlbacoreTask
    def execute(name)
      sftp = Sftp.new
      sftp.load_config_by_task_name(name)
      call_task_block(sftp)
      sftp.upload
    end
  end
end
