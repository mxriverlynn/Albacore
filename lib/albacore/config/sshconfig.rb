require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module Ssh
    @sshconfig = OpenStruct.new.extend(OpenStructToHash)

    def self.sshconfig
      @sshconfig
    end

    def ssh
      config = Ssh.sshconfig
      yield(config) if block_given?
      config
    end
  end
end

class Albacore::Configuration
  include Configuration::Ssh
end
