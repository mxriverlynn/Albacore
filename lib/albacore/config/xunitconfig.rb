require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module XUnit
    include Albacore::Configuration

    def self.xunitconfig
      @xunitconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def xunit
      config = XUnit.xunitconfig
      yield(config) if block_given?
      config
    end
  end
end

