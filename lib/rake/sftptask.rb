require 'rake/tasklib'

module Albacore
	class SftpTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:sftp, &block)
			@name = name
			@sftp = Sftp.new
			@block = block
			define
		end
		
		def define
			task name do
				@block.call(@sftp) unless @block.nil?
				@sftp.upload
			end
		end
	end
end
