require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module PLink
    @plinkconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.plinkconfig
      @plinkconfig
    end

    def plink
      config = PLink.plinkconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::PLink
end
