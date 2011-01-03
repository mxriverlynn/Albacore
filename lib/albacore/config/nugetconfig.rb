require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module NuGet
    include Albacore::Configuration

    def self.nugetconfig
      @config ||= OpenStruct.new.extend(OpenStructToHash).extend(NuGet)
    end

    def nuget
      @config ||= NuGet.nugetconfig
      yield(@config) if block_given?
      @config
    end
    
  end
end
