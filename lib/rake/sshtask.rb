require 'rake/tasklib'

module Albacore
	def self.ssh(name=:ssh, *args, &block)
		SshTask.new(name, *args, &block)
	end
	
	class SshTask < Albacore::AlbacoreTask
		def execute(task_args)
			@ssh = Ssh.new
			@block.call(@ssh, *task_args) unless @block.nil?
			@ssh.execute
		end
	end
end
