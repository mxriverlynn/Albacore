require 'albacore/albacoremodel'
require 'albacore/config/cscconfig'
require 'albacore/support/supportlinux'

class CSC
  include AlbacoreModel
  include RunCommand
  include Configuration::CSC
  include SupportsLinuxEnvironment

  attr_accessor :output, :target
  attr_array :compile, :references

  def initialize
    super()
    update_attributes csc.to_hash
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
