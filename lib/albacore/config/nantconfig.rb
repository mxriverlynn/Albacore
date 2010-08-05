require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module NAnt
    include Albacore::Configuration

    def self.nantconfig
      @nantconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def nant
      config = NAnt.nantconfig
      yield(config) if block_given?
      config
    end
  end
end

