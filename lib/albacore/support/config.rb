module Albacore
  class << self
  	attr_accessor :yaml_config_folder
  	attr_accessor :log_level

    def configure
      yield(configuration) if block_given?
    end

    def configuration 
      @configuration ||= Configuration.new
    end
  end

  class Configuration
  end
end
