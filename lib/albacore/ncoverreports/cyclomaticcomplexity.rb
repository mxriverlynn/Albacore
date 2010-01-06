require 'albacore/support/albacore_helper'

module NCover
  class CyclomaticComplexity
    include YAMLConfig
    
    attr_accessor :maximum, :item_type 
    
    def initialize(params={})
      @maximum = 100
      @item_type = :View
      parse_config(params) unless params.nil?
      super()
    end
    
    def get_coverage_options
      options = "CyclomaticComplexity"
      options << ":#{maximum}" unless maximum.nil?
      options << ":#{item_type}" unless item_type.nil?
      options
    end
  end
end