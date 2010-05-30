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
    def initialize
      @paths = {}
      @commands = {}
    end

    def metaclass
      class << self
        self
      end
    end

    def add_configuration(name, &block)
      self.class.send(:define_method, name, &block) 
    end

    def add_path(name, path)
      @paths[name] = path
    end

    def get_path(name)
      @paths[name]
    end
  end
end
