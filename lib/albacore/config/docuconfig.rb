require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module Docu
    @docuconfig = OpenStruct.new.extend(OpenStructToHash)
    def self.docuconfig
      @docuconfig
    end

    def docu
      config = Docu.docuconfig
      yield(config) if block_given?
      config
    end

    def self.included(obj)
      self.docuconfig.command = "Docu.exe"
    end
  end
end

class Albacore::Configuration
  include Configuration::Docu
end
