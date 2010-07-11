require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module XUnit
    @xunitconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.xunitconfig
      @xunitconfig
    end

    def xunit
      config = XUnit.xunitconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::XUnit
end
