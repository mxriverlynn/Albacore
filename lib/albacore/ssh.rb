require 'albacore/support/albacore_helper'
require 'net/ssh'

class Ssh
	include YAMLConfig
	include Logging
	
	attr_accessor :server, :username, :password, :commands
	
	def initialize
		super()
		@commands = []
	end
	
	def execute()
		Net::SSH.start(@server, @username, :password => @password) do |ssh|
			@commands.each{|cmd|
				@logger.info "Executing remote command: #{cmd}"
				output = ssh.exec!(cmd)
				@logger.info 'SSH output: '
				@logger.info output
			}
		end
	end
end