require 'logger'

module Logging
  
  attr_accessor :logger, :current_log_device
  
  def initialize
    create_logger(STDOUT, Logger::INFO)
    super()
  end
  
  def log_device=(logdev)
    level = @logger.level
    create_logger(logdev, level)
  end
  
  def log_level=(level)
    if (level == :verbose)
      loglevel = Logger::DEBUG
    else
      loglevel = Logger::INFO
    end
    create_logger(@current_log_device, loglevel)
  end
  
  def create_logger(device, level)
    @current_log_device = device
    @logger = Logger.new(device)
    
    level = Logger::DEBUG if Albacore::log_level == :verbose
    @logger.level = level
  end
  
end