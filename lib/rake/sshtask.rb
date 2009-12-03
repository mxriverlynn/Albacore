require 'rake/tasklib'

module Albacore
	class SshTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:ssh, &block)
			@name = name
			@block = block
			define
		end
		
		def define
			task name do
				@ssh = Ssh.new
				@block.call(@ssh) unless @block.nil?
				@ssh.execute
			end
		end
	end
end
