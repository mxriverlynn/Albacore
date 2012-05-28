require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module MSDeploy
    include Albacore::Configuration

    def msdeploy
      @msdeployconfig ||= OpenStruct.new.extend(OpenStructToHash)
      yield(@msdeployconfig) if block_given?
      @msdeployconfig
    end
  end
end

