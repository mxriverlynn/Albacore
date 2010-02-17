require 'albacore/support/albacore_helper'

class Renamer
  include YAMLConfig
  include Failure
  
  attr_accessor :actual_name, :target_name
  
  def rename
    if (@actual_name.nil? || @target_name.nil?)
      fail "actual_name and target_name cannot be nil"
    else
      File.rename(@actual_name, @target_name)
    end
  end
  
end
