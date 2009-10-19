require File.join(File.dirname(__FILE__), 'support', 'albacore_helper')
require 'net/sftp'

class Sftp
	include YAMLConfig
	include Logging
	
	attr_accessor :server, :username, :password, :local_file, :remote_file
	
	def initialize
		super()
	end	
	
	def upload()
		Net::SFTP.start(@server, @username, :password => @password) do |sftp|
			sftp.upload!(@local_file, @remote_file)
		end
	end
end