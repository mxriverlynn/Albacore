require 'albacore/support/albacore_helper'
require 'net/sftp'

class Sftp
	include YAMLConfig
	include Logging
	
	attr_accessor :server, :username, :password, :upload_files
	
	def initialize
		super()
		@upload_files = {}
	end	
	
	def upload()
		Net::SFTP.start(@server, @username, :password => @password) do |sftp|
			@logger.debug "Starting File Upload"
			@upload_files.each {|local_file, remote_file|
				@logger.debug "Uploading #{local_file} to #{remote_file}"
				sftp.upload!(local_file, remote_file)
			}
		end
	end
end