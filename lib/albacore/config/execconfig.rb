require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module Exec
    @execconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.execconfig
      @execconfig
    end

    def exec
      config = Exec.execconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::Exec
end
