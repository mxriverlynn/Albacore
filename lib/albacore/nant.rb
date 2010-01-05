require 'albacore/support/albacore_helper'

class NAnt
  include RunCommand
  include YAMLConfig
  include Logging
  
  def initialize
    super()
  end
  
end
