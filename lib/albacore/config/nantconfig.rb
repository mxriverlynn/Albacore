require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module NAnt
    @nantconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.nantconfig
      @nantconfig
    end

    def nant
      config = NAnt.nantconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::NAnt
end
