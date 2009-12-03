require 'albacore/support/albacore_helper'
require 'net/ssh'

class Ssh
	include YAMLConfig
	include Logging
	
	attr_accessor :server, :username, :password, :commands, :port, :key, :debug
  	
	def initialize
		super()
		@commands = []
	end
  
  	def get_connection_options
		options = {}
		options[:verbose] = :debug if @debug == true
		options[:password] = @password if @password
		options[:port] = @port if @port
		options[:keys] = [@key] if @key
		options
	end
	
	def execute()
    	warn_about_key if @key
    
		Net::SSH.start(@server, @username, get_connection_options) do |ssh|
			@commands.each{|cmd|
				@logger.info "Executing remote command: #{cmd}"
				output = ssh.exec!(cmd)
				@logger.info 'SSH output: '
				@logger.info output
			}
		end
	end
  
	def warn_about_key()
		info.debug 'When using a key, you need an SSH-Agent running to manage the keys.'
		info.debug 'On Windows, a recommended agent is called Pageant, downloadable from the Putty site.'
	end
  
end