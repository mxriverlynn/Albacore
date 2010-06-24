require 'ostruct'
require 'albacore/config/netversion'

module Configuration
  module CSC
    include ::Configuration::NetVersion

    @config = OpenStruct.new.extend(CSC)
    def self.cscconfig
      @config
    end

    def csc
      @config ||= CSC.cscconfig
    end

    def self.included(mod)
      self.cscconfig.use :net40
    end

    def use(netversion)
      csc.path = File.join(get_net_version(netversion), "csc.exe")
    end

  end
end

class Albacore::Configuration
  include Configuration::CSC
end
