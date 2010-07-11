require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module Unzip
    @unzipconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.unzipconfig
      @unzipconfig
    end

    def unzip
      config = Unzip.unzipconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::Unzip
end
