module Albacore
  class << self
    def configure
      @configuration ||= Configuration.new
      yield(@configuration) if block_given?
      @configuration
    end
  end

  class Configuration
   	attr_accessor :yaml_config_folder, :log_level, :plugindir

    def initialize
      @plugindir = File.expand_path(File.join(Dir.pwd, "albacore"))
      super()
    end
  end

  Dir.glob(File.join(Albacore.configure.plugindir, "*.rb")).each do |f| 
    require f 
  end
end
