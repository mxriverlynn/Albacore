module Albacore
  module Configuration
    def self.included(base)
      Albacore.configuration.extend(base) if (base.class == Module)
    end
  end

  class ConfigData
   	attr_accessor :yaml_config_folder, :log_level
    attr_accessor :plugindir

    def initialize
      @plugindir = File.expand_path(File.join(Dir.pwd, "albacore"))
    end
  end

  class << self
    def configure
      yield(configuration) if block_given?
      configuration
    end

    def configuration
      @configuration ||= ConfigData.new
    end
  end
end
