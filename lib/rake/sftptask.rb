require 'rake/tasklib'

def sftptask(name=:sftp, *args, &block)
	Albacore::SftpTask.new(name, *args, &block)
end
	
module Albacore
	class SftpTask < Albacore::AlbacoreTask
		def execute(task_args)
			@sftp = Sftp.new
			@block.call(@sftp, *task_args) unless @block.nil?
			@sftp.upload
		end
	end
end
