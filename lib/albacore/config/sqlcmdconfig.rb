require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module SQLCmd
    @sqlcmdconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.sqlcmdconfig
      @sqlcmdconfig
    end

    def sqlcmd
      config = SQLCmd.sqlcmdconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::SQLCmd
end
