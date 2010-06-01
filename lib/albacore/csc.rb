require 'albacore/support/albacore_helper'

Albacore.configure do |config|
  config.add_path :csc, "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319"
end

class CSC
  extend AttrMethods
  include YAMLConfig
  include RunCommand
  include Logging

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
    params << @references.map{|r| "\"/reference:#{r.gsub("/","\\")}\""} unless @references.nil?
    params << @compile.map{|f| "\"#{f}\"".gsub("/", "\\")} unless @compile.nil?

    result = run_command "CSC", params
    
    failure_message = 'CSC Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
end
