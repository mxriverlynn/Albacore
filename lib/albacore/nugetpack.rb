require 'albacore/albacoretask'
require 'albacore/config/nugetpackconfig'
require 'albacore/support/supportlinux'

class NuGetPack
  include Albacore::Task
  include Albacore::RunCommand
  include Configuration::NuGetPack
  include SupportsLinuxEnvironment
  
  attr_accessor  :nuspec,
                 :output,
                 :base_folder,
                 :command
                 
  attr_hash :properties

  def initialize(command = "NuGet.exe") # users might have put the NuGet.exe in path
    super()
    update_attributes nugetpack.to_hash
    @command = command
  end

  def execute
  
    fail_with_message 'nuspec must be specified.' if @nuspec.nil?
    
    params = []
    params << "pack"
    params << "#{nuspec}"
    params << "-b #{base_folder}" unless @base_folder.nil?
    params << "-o #{output}" unless @output.nil?
    params << build_properties unless @properties.nil? || @properties.empty?
    
    merged_params = params.join(' ')
    
    @logger.debug "Build NuGet pack Command Line: #{merged_params}"
    result = run_command "NuGet", merged_params
    
    failure_message = 'NuGet Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end
  
  def build_properties
    option_text = []
    @properties.each do |key, value|
      option_text << "#{key}=\"#{value}\""
    end
    '-Prop ' + option_text.join(";")
  end
  
end