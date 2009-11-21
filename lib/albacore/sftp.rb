require 'net/sftp'

class Sftp
	include YAMLConfig
	include Logging
	
	attr_accessor :server, :username, :password, :local_file, :remote_file
	
	def initialize
		super()
		configure_if_config_exists('sftp')
	end
	
	
	def upload()
		Net::SFTP.start(@server, @username, :password => @password) do |sftp|
			sftp.upload!(@local_file, @remote_file)
		end
	end
end