require 'albacore/support/albacore_helper'

module NCover
  class SummaryReport
    include YAMLConfig
    
    attr_accessor :output_path
    
    def initialize
      @report_format = :Xml
      super()
    end
    
    def report_type
      :Summary
    end
    
    def report_format
      :Html
    end
  end
end