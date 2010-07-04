require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module NCoverConsole
    @ncoverconsoleconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.ncoverconsoleconfig
      @ncoverconsoleconfig
    end

    def ncoverconsole
      config = NCoverConsole.ncoverconsoleconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::NCoverConsole
end
