require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module XBuild
    include Albacore::Configuration

    def self.xbuildconfig
      @xbuildconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def xbuild
      config = XBuild.xbuildconfig
      yield(config) if block_given?
      config
    end
  end
end

