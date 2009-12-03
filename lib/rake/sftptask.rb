require 'rake/tasklib'

module Albacore
	def self.sftp(name=:sftp, *args, &block)
		SftpTask.new(name, *args, &block)
	end
	
	class SftpTask < Albacore::AlbacoreTask
		def execute(task_args)
			@sftp = Sftp.new
			@block.call(@sftp, *task_args) unless @block.nil?
			@sftp.upload
		end
	end
end
