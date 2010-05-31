require 'albacore/support/albacore_helper'

Albacore.configure do |config|
  config.add_path :csc, "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319"
end

class CSCConfig
  extend AttrMethods
  include YAMLConfig
  include Logging

  attr_array :compile
end

class CSC
  include RunCommand
  include Logging

  def initialize
    @command = File.join(Albacore.configuration.get_path(:csc), "csc.exe")
    super()
  end

  def execute(config)
    params = []
    puts "---------------#{config.compile.inspect}"
    params = config.compile.map{|f| "\"#{f}\""}
    result = run_command "CSC", params
    
    failure_message = 'CSC Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
end
