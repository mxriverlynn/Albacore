require File.join(File.dirname(__FILE__), 'support', 'albacore_helper')
require 'net/ssh'

class Ssh
	include YAMLConfig
	include Logging
	
	attr_accessor :server, :username, :password, :command
	
	def initialize
		super()
		configure_if_config_exists('ssh')
	end
	
	
	def execute()
		Net::SSH.start(@server, @username, :password => @password) do |ssh|
			output = ssh.exec!(@command)
			@logger.info 'SSH output: '
			@logger.info output
		end
	end
end