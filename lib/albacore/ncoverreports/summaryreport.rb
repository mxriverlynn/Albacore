require 'albacore/albacoremodel'

module NCover
  class SummaryReport
    include AlbacoreModel
    
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
