require 'albacore/albacoretask'
require 'albacore/config/nugetupdateconfig'
require 'albacore/support/supportlinux'

class NuGetUpdate
  include Albacore::Task
  include Albacore::RunCommand
  include Configuration::NuGetUpdate
  include SupportsLinuxEnvironment
  
  attr_accessor :input_file,
                :repository_path,
                :safe
  
  attr_array    :source,
                :id

  def initialize(command = "NuGet.exe") # users might have put the NuGet.exe in path
    super()
    update_attributes nugetupdate.to_hash
    @command = command
  end

  def execute
    params = get_command_parameters
    
    @logger.debug "Build NuGet Update Command Line: #{params}"
    result = run_command "NuGet", params
    
    fail_with_message 'NuGet Update Failed. See Build Log For Detail' unless result
  end
  
  def get_command_parameters
    fail_with_message 'An input file must be specified (packages.config|solution).' if self.input_file.nil?
    
    params = []
    params << "update"
    params << "#{self.input_file}"
    params << "-Source #{get_array_parameter(self.source)}" unless self.source.nil?
    params << "-Id #{get_array_parameter(self.id)}" unless self.id.nil?
    params << "-RepositoryPath #{self.repository_path}" unless self.repository_path.nil?
    params << "-Safe" if self.safe
    
    merged_params = params.join(' ')
  end
  
  def get_array_parameter(arr)
    "\"#{arr.join(';')}\""
  end
  
end