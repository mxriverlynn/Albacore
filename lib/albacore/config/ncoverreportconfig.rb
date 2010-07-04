require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module NCoverReport
    @ncoverreportconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.ncoverreportconfig
      @ncoverreportconfig
    end

    def ncoverreport
      config = NCoverReport.ncoverreportconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::NCoverReport
end
