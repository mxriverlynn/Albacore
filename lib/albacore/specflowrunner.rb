require 'albacore/support/albacore_helper'

class SpecFlowRunner
  extend AttrMethods
  include RunCommand
  include YAMLConfig
  
  attr_array :assemblies, :options
  
  def initialize(path_to_command='')
  	@path_to_command = 'specflow.exe'
    @path_to_command = path_to_command unless path_to_command.empty?
    @options=[]
    @projectfiles =[]
    super()
  end
  
  def get_command_line
    command_params = []
    command_params << @path_to_command
    command_params << get_command_parameters
    commandline = command_params.join(" ")
    @logger.debug "Build SpecFlow Command Line: " + commandline
    commandline
  end
  
  def get_command_parameters
    command_params = []
    command_params << @projectfiles.map{|asm| "\"#{asm}\""}.join(' ') unless @projectfiles.nil?
	command_params << @options.join(" ") unless @options.nil?
    command_params
  end
  
  def execute()
    command_params = get_command_parameters
    result = run_command "nunitexecutionreport", command_params.join(" ")
    
    failure_message = 'SpecFlow Failed. See Build Log For Detail.'
    fail_with_message failure_message if !result
  end  
end