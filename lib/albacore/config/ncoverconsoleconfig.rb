require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module NCoverConsole
    include Albacore::Configuration

    def self.ncoverconsoleconfig
      @ncoverconsoleconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def ncoverconsole
      config = NCoverConsole.ncoverconsoleconfig
      yield(config) if block_given?
      config
    end
  end
end

