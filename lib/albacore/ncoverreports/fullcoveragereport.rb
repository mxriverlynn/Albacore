require 'albacore/support/albacore_helper'

module NCover
  class FullCoverageReport
    include YAMLConfig
    
    attr_accessor :output_path
    
    def initialize
      super()
    end
    
    def report_type
      :FullCoverageReport
    end
    
    def report_format
      :Html
    end
  end
end