require 'albacore/support/albacore_helper'

Albacore.configure do |config|
  config.add_path :csc, ""
end

class CSCConfig
  extend AttrMethods
  include YAMLConfig
  include Logging

  attr_array :compile

  def initialize
    command = :csc
    super()
  end
end

class CSC
  include RunCommand
  include Logging

  def execute(config)
    result = run_command "CSC", command_parameters.join(" ")
    
    failure_message = 'CSC Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
end
