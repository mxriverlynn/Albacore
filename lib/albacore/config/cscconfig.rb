require 'ostruct'
require 'albacore/config/netversion'
require 'albacore/support/openstruct'

module Configuration
  module CSC
    include Configuration::NetVersion

    @config = OpenStruct.new.extend(OpenStructToHash).extend(CSC)
    def self.cscconfig
      @config
    end

    def csc
      @config ||= CSC.cscconfig
      yield(@config) if block_given?
      @config
    end

    def self.included(mod)
      self.cscconfig.use :net40
    end

    def use(netversion)
      self.command = File.join(get_net_version(netversion), "csc.exe")
    end

  end
end

class Albacore::Configuration
  include Configuration::CSC
end
