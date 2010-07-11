require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module Zip
    @zipconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.zipconfig
      @zipconfig
    end

    def zip
      config = Zip.zipconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::Zip
end
