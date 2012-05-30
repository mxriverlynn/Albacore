require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module NuGetUpdate
    include Albacore::Configuration

    def self.nugetupdateconfig
      @config ||= OpenStruct.new.extend(OpenStructToHash).extend(NuGetUpdate)
    end

    def nugetupdate
      config ||= NuGetUpdate.nugetupdateconfig
      yield(config) if block_given?
      config
    end
    
  end
end