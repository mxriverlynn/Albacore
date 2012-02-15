require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module AssemblyInfo
    include Albacore::Configuration
    
    def self.asmconfig
      @config ||= OpenStruct.new.extend(OpenStructToHash).extend(AssemblyInfo)
    end
    
    # this is the key: Albacore.configure( hash => hash.assemblyinfo ) 
    def assemblyinfo
      config ||= AssemblyInfo.asmconfig
      yield(config) if block_given?
      config
    end
    
  end
end
