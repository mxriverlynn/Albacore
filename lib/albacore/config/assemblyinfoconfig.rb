require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module AssemblyInfo
    @asmconfig = OpenStruct.new.extend(OpenStructToHash)
    def self.asmconfig
      @asmconfig
    end

    def assemblyinfo
      config = AssemblyInfo.asmconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::AssemblyInfo
end
