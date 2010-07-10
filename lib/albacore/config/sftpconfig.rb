require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module Sftp
    @sftpconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.sftpconfig
      @sftpconfig
    end

    def sftp
      config = Sftp.sftpconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::Sftp
end
