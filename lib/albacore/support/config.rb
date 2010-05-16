module Albacore
  class << self
  	attr_accessor :yaml_config_folder
  	attr_accessor :log_level

    def configure
      @configuration = Configuration.new
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

    def add_path(name, path)
      @paths[name] = path
    end

    def get_path(name)
      @paths[name]
    end

    def add_command(name, path, command=nil)
      @commands[name] = Command.new path, command
    end

    def get_command(name)
      cmd = @commands[name]
      msg = "The '#{name.to_s}' task has not been configured"
      fail msg if cmd.nil?
      cmd.fullpath 
    end

    def method_missing(symbol, *args)
      if args.count == 2
        add_command symbol, args[0], args[1]
      else
        super symbol, *args
      end
    end
  end #Configuration

  class Command
    def initialize(path, command)
      @path = path
      @command = command
    end

    def fullpath
      path = Albacore.configuration.get_path(@path) || @path
      File.join(path, @command)
    end
  end
end
