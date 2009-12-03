require 'rake/tasklib'

def sshtask(name=:ssh, *args, &block)
	Albacore::SshTask.new(name, *args, &block)
end
	
module Albacore
	class SshTask < Albacore::AlbacoreTask
		def execute(task_args)
			@ssh = Ssh.new
			@block.call(@ssh, *task_args) unless @block.nil?
			@ssh.execute
		end
	end
end
