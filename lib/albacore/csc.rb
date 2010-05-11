require 'albacore/support/albacore_helper'

class CSC
  extend AttrMethods
  include RunCommand
  include YAMLConfig
  include Logging

  attr_array :compile

  def execute
  end

end
