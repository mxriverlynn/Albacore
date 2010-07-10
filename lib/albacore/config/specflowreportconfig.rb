require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module SpecFlowReport
    @specflowreportconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.specflowreportconfig
      @specflowreportconfig
    end

    def specflowreport
      config = SpecFlowReport.specflowreportconfig
      yield(config) if block_given?
      config
    end

    def self.included(obj)
      specflowreportconfig.command = 'specflow.exe'
      specflowreportconfig.report = 'nunitexecutionreport'
    end
  end
end

class Albacore::Configuration
  include Configuration::SpecFlowReport
end
