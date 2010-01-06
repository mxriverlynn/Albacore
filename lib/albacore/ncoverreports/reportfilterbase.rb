require 'albacore/support/albacore_helper'

module NCover
  class ReportFilterBase
    include YAMLConfig
    
    attr_accessor :filter, :filter_type, :item_type, :is_regex
    
    def initialize(item_type, params={})
      @filter = ""
      @item_type = item_type
      @is_regex = false
      @filter_type = :exclude
      parse_config(params) unless params.nil?
      super()
    end
  
    def get_filter_options
      filter = "\"#{@filter}\""
      filter << ":#{@item_type}"
      filter << ":#{@is_regex}"
      filter << ":#{(@filter_type == :include)}"
      filter
    end
  end
end  