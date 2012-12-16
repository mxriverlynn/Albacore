require 'albacore/albacoretask'

class OpenCover
  include Albacore::Task
  include Albacore::RunCommand
  
  attr_accessor :deploy_package, :parameters_file, :server, :username, :password, :additional_parameters, :noop
  
  def initialize
    super()
    update_attributes Albacore.configuration.opencover.to_hash
  end
  
end  