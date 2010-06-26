require 'albacore/albacoremodel'
require 'albacore/config/nunitconfig'

class NUnitTestRunner
  include AlbacoreModel
  include RunCommand
  include Configuration::NUnit
  
  attr_array :assemblies, :options
  
  def initialize(command=nil)
    @options=[]
    @assemblies=[]
    update_attributes nunit.to_hash
    @command = command unless command.nil?
    super()
  end
  
  def get_command_line
    command_params = []
    command_params << @command
    command_params << get_command_parameters
    commandline = command_params.join(" ")
    @logger.debug "Build NUnit Test Runner Command Line: " + commandline
    commandline
  end
  
  def get_command_parameters
    command_params = []
    command_params << @options.join(" ") unless @options.nil?
    command_params << @assemblies.map{|asm| "\"#{asm}\""}.join(' ') unless @assemblies.nil?
    command_params
  end
  
  def execute()
    command_params = get_command_parameters
    result = run_command "NUnit", command_params.join(" ")
    
    failure_message = 'NUnit Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end  
end
