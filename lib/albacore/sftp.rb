require 'albacore/support/albacore_helper'
require 'net/sftp'

class Sftp
	include YAMLConfig
	include Logging
	
	attr_accessor :server, :username, :password, :upload_files, :port, :key, :debug
  
	def initialize
		super()
		@upload_files = {}
	end	
	
	def get_connection_options
		options = {}
		options[:verbose] = :debug if @debug == true
		options[:password] = @password if @password
		options[:port] = @port if @port
		options[:keys] = [@key] if @key
		options
	end
  
	def upload()
		warn_about_key if @key
    
		Net::SFTP.start(@server, @username, get_connection_options) do |sftp|
			@logger.debug "Starting File Upload"
			@upload_files.each {|local_file, remote_file|
				@logger.debug "Uploading #{local_file} to #{remote_file}"
				sftp.upload!(local_file, remote_file)
			}
		end
	end

	def warn_about_key()
		info.debug 'When using a key, you need an SSH-Agent running to manage the keys.'
		info.debug 'On Windows, a recommended agent is called Pageant, downloadable from the Putty site.'
	end
end