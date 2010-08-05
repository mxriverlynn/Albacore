module Albacore
  class << self
    def configure
      yield(configuration) if block_given?
      configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Configuration
   	attr_accessor :yaml_config_folder, :log_level
    attr_reader :plugindir

    def initialize
      @plugindir = File.expand_path(File.join(Dir.pwd, "albacore"))
    end
  end

  Dir.glob(File.join(Albacore.configuration.plugindir, "*.rb")).each do |f| 
    require f 
  end
end
