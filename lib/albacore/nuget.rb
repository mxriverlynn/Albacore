require 'albacore/albacoretask'
require 'albacore/config/nugetconfig'
require 'albacore/support/supportlinux'

class NuGet
  include Albacore::Task
  include Albacore::RunCommand
  include Configuration::NuGet
  include SupportsLinuxEnvironment
  
  attr_accessor  :nuspec_file,
                 :output,
                 :base_folder,
                 :command

  def initialize(command = nil)
    super()
    update_attributes nuget.to_hash
    @command = command unless command.nil?
    @command = "NuGet" if @command.nil? # users might have put the NuGet.exe in path
  end

  def execute
  
    fail_with_message 'nuspec_file must be specified.' if @nuspec_file.nil?
    
    params = []
    params << "pack"
    params << "#{nuspec_file}"
    params << "-b #{base_folder}" unless @base_folder.nil?
    params << "-o #{output}" unless @output.nil?
    
    merged_params = params.join(' ')
    
    @logger.debug "Build NuGet pack Command Line: #{merged_params}" 
    result = run_command "NuGet", merged_params
    
    failure_message = 'NuGet Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
  
end