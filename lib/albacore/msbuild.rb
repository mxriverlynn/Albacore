require 'albacore/support/albacore_helper'

class MSBuild
  extend AttrMethods
  include RunCommand
  include YAMLConfig
  include Logging
  
  attr_accessor :solution, :verbosity
  attr_array :targets
  attr_hash :properties
  
  def initialize
    @path_to_command = build_path_to_command
    super()
  end
  
  def build_path_to_command
    win_dir = ENV['windir'] || ENV['WINDIR']
    win_dir = 'C:/Windows' if win_dir.nil?
    
    File.join(win_dir.dup, 'Microsoft.NET', 'Framework', 'v3.5', 'MSBuild.exe')
  end
  
  def build
    build_solution(@solution)
  end
  
  def build_solution(solution)
    check_solution solution
    
    command_parameters = []
    command_parameters << "\"#{solution}\""
    command_parameters << "\"/verbosity:#{@verbosity}\"" if @verbosity != nil
    command_parameters << build_properties if @properties != nil
    command_parameters << "\"/target:#{build_targets}\"" if @targets != nil
    
    result = run_command "MSBuild", command_parameters.join(" ")
    
    failure_message = 'MSBuild Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
  
  def check_solution(file)
    return if file
    msg = 'solution cannot be nil'
    fail_with_message msg
  end
  
  def build_targets
    @targets.join ";"
  end

  def build_properties
    option_text = []
    @properties.each do |key, value|
      option_text << "/p:#{key}\=\"#{value}\""
    end
    option_text.join(" ")
  end
end
