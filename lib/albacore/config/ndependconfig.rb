require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module NDepend
    include Albacore::Configuration

    def self.ndependconfig
      @ndependconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def ndepend
      config = NDepend.ndependconfig
      yield(config) if block_given?
      config
    end
  end
end

