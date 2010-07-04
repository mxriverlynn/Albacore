require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module NDepend
    @ndependconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.ndependconfig
      @ndependconfig
    end

    def ndepend
      config = NDepend.ndependconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::NDepend
end
