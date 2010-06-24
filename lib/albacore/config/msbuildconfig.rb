require 'ostruct'
require 'albacore/config/netversion'

module Configuration
  module MSBuild
    include ::Configuration::NetVersion

    @config = OpenStruct.new.extend(MSBuild)
    def self.msbuildconfig
      @config
    end

    def msbuild
      @config ||= MSBuild.msbuildconfig
    end

    def self.included(mod)
      self.msbuildconfig.use :net40
    end

    def use(netversion)
      msbuild.path = File.join(get_net_version(netversion), "MSBuild.exe")
    end
  end
end

class Albacore::Configuration
  include Configuration::MSBuild
end
