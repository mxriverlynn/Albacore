require 'albacore/support/albacore_helper'

class Docu
  extend AttrMethods
  include RunCommand
  include YAMLConfig
  
  attr_accessor :output_location
  attr_array :assemblies, :xml_files
  
  def initialize(path_to_command='docu.exe')
    @path_to_command = path_to_command
    @assemblies = []
    @xml_files = []
    @output_location = ""
    super()
  end
  
  def execute
    if @assemblies.empty?
      fail_with_message 'Docu Failed. No assemblies specified'
      return
    end
  
    command_params = get_command_parameters
    success = run_command 'Docu', command_params.join(' ')
  
    fail_with_message 'Docu Failed. See Build Log For Detail' unless success
  end
  
  private
  def get_command_parameters
    command_params = []
    command_params << @assemblies.join(' ') unless @assemblies.nil?
    command_params << @xml_files.join(' ') unless @xml_files.nil?
    command_params << " --output=\"#{@output_location}\" " unless @output_location.empty?
    command_params
  end
end