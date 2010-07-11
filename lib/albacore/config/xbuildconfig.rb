require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module XBuild
    @xbuildconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.xbuildconfig
      @xbuildconfig
    end

    def xbuild
      config = XBuild.xbuildconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::XBuild
end
