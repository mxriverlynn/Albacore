require 'ostruct'
require 'albacore/config/netversion'
require 'albacore/support/openstruct'

module Configuration
  module MSBuild
    include Configuration::NetVersion

    @config = OpenStruct.new.extend(OpenStructToHash).extend(MSBuild)
    def self.msbuildconfig
      @config
    end

    def msbuild
      @config ||= MSBuild.msbuildconfig
      yield(@config) if block_given?
      @config
    end

    def self.included(mod)
      self.msbuildconfig.use :net40
    end

    def use(netversion)
      msbuild.command = File.join(get_net_version(netversion), "MSBuild.exe")
    end
  end
end

class Albacore::Configuration
  include Configuration::MSBuild
end
