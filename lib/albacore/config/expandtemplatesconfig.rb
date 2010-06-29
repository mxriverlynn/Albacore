require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module ExpandTemplates
    @expconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.expconfig
      @expconfig
    end

    def expandtemplates
      config = ExpandTemplates.expconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::ExpandTemplates
end
