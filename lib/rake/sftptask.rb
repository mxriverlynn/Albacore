require 'rake/tasklib'

module Albacore
	class SftpTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:sftp)
			@name = name
			@sftp = Sftp.new
			yield @sftp if block_given?
			define
		end
		
		def define
			task name do
				@sftp.upload
			end
		end
	end
end
