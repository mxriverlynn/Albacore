require 'albacore/support/albacore_helper'

Albacore.configure do |config|
  config.add_path :csc, "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319"
end

module SupportsLinuxEnvironment
  attr_accessor :is_linux
  
  def initialize
    @is_linux = RUBY_PLATFORM.include? 'linux'
    super()
  end
  
  def format_reference(reference)
    "\"/reference:#{to_OS_format(reference)}\""
  end

  def format_path(path)
    "\"#{to_OS_format(path)}\""
  end

  def to_OS_format(input)
    formatted_input = @is_linux ? input : input.gsub("/", "\\")
	formatted_input
  end
end

class CSC
  extend AttrMethods
  include YAMLConfig
  include RunCommand
  include Logging
  include SupportsLinuxEnvironment

  attr_accessor :output, :target
  attr_array :compile, :references

  def initialize
    @command = File.join(Albacore.configuration.get_path(:csc), "csc.exe")
    super()
  end

  def execute
    params = []
    params << "\"/out:#{@output}\"" unless @output.nil?
    params << "/target:#{@target}" unless @target.nil?
    params << @references.map{|r| format_reference(r)} unless @references.nil?
    params << @compile.map{|f| format_path(f)} unless @compile.nil?

    result = run_command "CSC", params
    
    failure_message = 'CSC Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
end
