require File.join(File.dirname(__FILE__), 'support', 'albacore_helper')
require 'net/sftp'

class Sftp
	include YAMLConfig
	include Logging
	
	attr_accessor :server, :username, :password, :files_to_upload
	
	def initialize
		super()
		@files_to_upload = {}
	end	
	
	def upload()
		Net::SFTP.start(@server, @username, :password => @password) do |sftp|
			@logger.debug "Starting File Upload"
			@files_to_upload.each {|local_file, remote_file|
				@logger.debug "Uploading #{local_file} to #{remote_file}"
				sftp.upload!(local_file, remote_file)
			}
		end
	end
end