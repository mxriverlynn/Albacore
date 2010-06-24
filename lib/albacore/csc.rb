require 'albacore/support/albacore_helper'

class CSC
  extend AttrMethods
  include YAMLConfig
  include RunCommand
  include Logging
  include ::Configuration::CSC

  attr_accessor :output, :target
  attr_array :compile, :references

  def initialize
    @command = csc.path
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
