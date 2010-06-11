require 'albacore/support/albacore_helper'

class SpecFlowRunner
  extend AttrMethods
  include RunCommand
  include YAMLConfig
  
  attr_array :projects, :options
  
  def initialize(path_to_command='')
  	@path_to_command = path_to_command
    @options=[]
    @projects =[]
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
    if @projects.empty? then
    	failure_message = "SpecFlow Expects at list one project file"
    	@logger.debug failure_message
    	fail_with_message failure_message
	else
    	command_params << @projects.map{|asm| "\"#{asm}\""}.join(' ')
	end
    if @options.empty? then
    	command_params << "/xmlTestResult:TestResult.xml /out:specs.html"
	else
		command_params << @options.join(" ") 
	end 
    command_params
  end
  
  def execute()
    command_params = get_command_parameters
    result = run_command "specflow.exe", command_params.join(" ")
    
    failure_message = 'SpecFlow Failed. See Build Log For Detail.'
    fail_with_message failure_message if !result
  end  
end