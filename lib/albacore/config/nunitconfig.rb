require 'albacore/support/openstruct'

module Configuration
  module NUnit
    @config = OpenStruct.new.extend(OpenStructToHash).extend(NUnit)
    def self.nunitconfig
      @config
    end

    def nunit
      config = NUnit.nunitconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::NUnit
end
