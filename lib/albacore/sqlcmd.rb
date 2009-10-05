require File.join(File.dirname(__FILE__), 'support', 'albacorebase')
require 'yaml'

class SQLCmd
	include CommandBase
	include YAMLConfigBase
	
	attr_accessor :server, :database, :username, :password
	
	def run
		
		
	end
	
end