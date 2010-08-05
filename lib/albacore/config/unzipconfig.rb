require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module Unzip
    include Albacore::Configuration

    def self.unzipconfig
      @unzipconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def unzip
      config = Unzip.unzipconfig
      yield(config) if block_given?
      config
    end
  end
end

