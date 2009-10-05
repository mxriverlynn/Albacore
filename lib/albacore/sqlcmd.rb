require File.join(File.dirname(__FILE__), 'support', 'albacorebase')
require 'yaml'

class SQLCmd
	include CommandBase
	include YAMLConfigBase
	
	attr_accessor :server, :database, :username, :password, :scripts, :variables
	
	def initialize
		super()
		@require_valid_command = false
		@scripts=[]
		@variables={}
	end
	
	def run
		check_command
		return if @failed
		
		cmd_params=[]
		cmd_params << build_parameter("S", @server) unless @server.nil?
		cmd_params << build_parameter("d", @database) unless @database.nil?
		cmd_params << build_parameter("U", @username) unless @username.nil?
		cmd_params << build_parameter("P", @password) unless @password.nil?
		cmd_params << build_variable_list if @variables.length > 0
		cmd_params << build_script_list if @scripts.length > 0
		
		result = run_command "SQLCmd", cmd_params.join(" ")
		
		failure_msg = 'SQLCmd Failed. See Build Log For Detail.'
		fail_with_message failure_msg if !result
	end
	
	def check_command
		return if @path_to_command
		fail_with_message 'SQLCmd.path_to_command cannot be nil.'
	end
	
	def build_script_list
		@scripts.map{|s| "-i \"#{s}\""}.join(" ")
	end
	
	def build_parameter(param_name, param_value)
		"-#{param_name} \"#{param_value}\""
	end
	
	def build_variable_list
		@variables.map{|k,v| "-v \"#{k}\"=\"#{v}\""}
	end
	
end