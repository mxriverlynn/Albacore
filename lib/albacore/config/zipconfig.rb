require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module Zip
    include Albacore::Configuration

    def self.zipconfig
      @zipconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def zip
      config = Zip.zipconfig
      yield(config) if block_given?
      config
    end
  end
end

