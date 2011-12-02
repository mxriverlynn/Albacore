require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module CopyDir
    include Albacore::Configuration

    def copydir
      @copydirconfig ||= OpenStruct.new.extend(OpenStructToHash)
      yield(@copydirconfig) if block_given?
      @copydirconfig
    end
  end
end

