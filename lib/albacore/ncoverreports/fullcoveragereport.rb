require 'albacore/albacoremodel'

module NCover
  class FullCoverageReport
    include AlbacoreModel
    
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
