require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module MSpec

    def self.mspecconfig
      @mspecconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def mspec
      config = MSpec.mspecconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::MSpec
end
