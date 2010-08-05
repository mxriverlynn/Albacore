require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module Exec
    include Albacore::Configuration

    def self.execconfig
      @execconfig ||= OpenStruct.new.extend(OpenStructToHash)
    end

    def exec
      config = Exec.execconfig
      yield(config) if block_given?
      config
    end
  end
end

