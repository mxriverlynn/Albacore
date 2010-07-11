module Albacore
  class << self
    def configure
      @configuration ||= Configuration.new
      yield(@configuration) if block_given?
      @configuration
    end
  end

  class Configuration
   	attr_accessor :yaml_config_folder
  	attr_accessor :log_level
 end
end
