require 'albacore/support/albacore_helper'

class XUnitTestRunner
  extend AttrMethods
  include RunCommand
  include YAMLConfig

  attr_accessor :html_output, :assembly
  attr_array :options

  def initialize(path_to_command='')
    @path_to_command = path_to_command
    @options=[]
    super()
  end

  def get_command_line
    command_params = []
    command_params << @path_to_command
    command_params << get_command_parameters
    commandline = command_params.join(" ")
    @logger.debug "Build XUnit Test Runner Command Line: " + commandline
    commandline
  end
  
  def get_command_parameters
    command_params = []
    command_params << assembly.inspect unless @assembly.nil?
    command_params << @options.join(" ") unless @options.nil?
    command_params << build_html_output unless @html_output.nil?
    command_params
  end

  def execute()
    command_params = get_command_parameters
    result = run_command "XUnit", command_params.join(" ")

    failure_message = 'XUnit Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end

  def build_html_output
    "/html #{@html_output}"
  end
end