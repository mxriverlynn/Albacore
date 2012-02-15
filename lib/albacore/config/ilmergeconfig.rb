 require 'ostruct'
require 'albacore/config/netversion'
require 'albacore/support/openstruct'

module Configuration
  module ILMerge
    include Albacore::Configuration
    
    def self.ilmergeconfig
      @config ||= OpenStruct.new.extend(OpenStructToHash).extend(ILMerge)
    end
    
    def ilmerge
      config ||= ILMerge.ilmergeconfig
      yield(config) if block_given?
      config
    end
    
    def use_resolver r
      self.ilmergeconfig.resolver = r
    end
    
  end
end