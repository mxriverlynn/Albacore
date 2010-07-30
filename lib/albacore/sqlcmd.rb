require 'albacore/support/albacore_helper'

class SQLCmd
  extend AttrMethods
  include RunCommand
  include YAMLConfig
  
  attr_accessor :server, :database, :username, :password
  attr_array :scripts
  attr_hash :variables
  
  def initialize
    @require_valid_command = false
    @scripts=[]
    @variables={}
    super()
  end
  
  def run
    return unless check_command
    
    cmd_params=[]
	serverParam = @server.nil? ? build_parameter("S", ".") : build_parameter("S", @server)
	cmd_params << serverParam
    cmd_params << build_parameter("d", @database) unless @database.nil?
    integratedParam = "-E"
	if ((!(@username.nil?)) and (!(@password.nil?)))
		integratedParam = build_parameter("U", @username) + " " + build_parameter("P", @password)
	end
	cmd_params << integratedParam
	cmd_params << build_variable_list if @variables.length > 0
    cmd_params << "-b" if @scripts.length > 1
    cmd_params << build_script_list if @scripts.length > 0
    
    result = run_command "SQLCmd", cmd_params.join(" ")
    
    failure_msg = 'SQLCmd Failed. See Build Log For Detail.'
    fail_with_message failure_msg if !result
  end
  
  def check_command
    sql2008cmdPath = File.join(ENV['SystemDrive'],'program files','microsoft sql server','100','tools','binn', 'sqlcmd.exe')
    @path_to_command = sql2008cmdPath if File.exists?(sql2008cmdPath)
    return true
    
    sql2005cmdPath = File.join(ENV['SystemDrive'],'program files','microsoft sql server','90','tools','binn', 'sqlcmd.exe')
    @path_to_command = sql2005cmdPath if File.exists?(sql2005cmdPath)
    return true
    
    return true if (!@path_to_command.nil?)
    
    fail_with_message 'SQLCmd.path_to_command cannot be nil.'
    return false
  end
  
  def build_script_list
    @scripts.map{|s| "-i \"#{s.strip}\""}.join(" ")
  end
  
  def build_parameter(param_name, param_value)
    "-#{param_name} \"#{param_value}\""
  end
  
  def build_variable_list
    vars = []
    @variables.each do |k,v| 
      vars << "-v #{k}=#{v}"
    end
    vars.join(" ")
  end
  
end