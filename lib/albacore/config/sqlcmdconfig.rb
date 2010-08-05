require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module SQLCmd
    include Albacore::Configuration

    def self.sqlcmdconfig
      @sqlcmdconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def sqlcmd
      config = SQLCmd.sqlcmdconfig
      yield(config) if block_given?
      config
    end
  end
end

