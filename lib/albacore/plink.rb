require 'albacore/albacoremodel'
require 'albacore/config/plinkconfig'

class PLink
  include AlbacoreModel
  include RunCommand
  include Configuration::PLink

  attr_accessor :host, :port, :user, :key, :verbose
  attr_array :commands

  def initialize()
      @port = 22
      @verbose = false
      @commands = []
      super()
      update_attributes plink.to_hash
  end

  def run()
    return unless check_command
    
    parameters = create_parameters
    result = run_command "Plink", parameters.join(" ")
    failure_message = 'Command Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
  
  def create_parameters
    parameters = []
    parameters << "#{@user}@#{@host} -P #{@port} "
    parameters << build_parameter("i", @key) unless @key.nil?
    parameters << "-batch"
    parameters << "-v" if @verbose
    parameters << @commands
    @logger.debug "PLink Parameters" + parameters.join(" ")
    return parameters
  end

  def build_parameter(param_name, param_value)
    "-#{param_name} #{param_value}"
  end

  def check_command
    return true if @command
    fail_with_message 'Plink.command cannot be nil.'
    return false
  end
end
