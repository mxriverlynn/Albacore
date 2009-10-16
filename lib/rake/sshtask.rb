require 'rake/tasklib'

module Albacore
	class SshTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:ssh)
			@name = name
			@ssh = Ssh.new
			yield @ssh if block_given?
			define
		end
		
		def define
			task name do
				@ssh.execute
			end
		end
	end
end
