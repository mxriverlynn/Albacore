require 'albacore/albacoretask'
begin
  require 'win32/registry'
rescue LoadError => e
  puts "Could not load Win32 lib, on unix machine?"
end

class MSDeploy
  include Albacore::Task
  include Albacore::RunCommand
  
  attr_accessor :deploy_package, :parameters_file, :server, :username, :password, :additional_parameters, :noop
  
  def initialize
    @deploy_package = Dir.pwd
    @noop = false
    super()
    update_attributes Albacore.configuration.msdeploy.to_hash
  end
    
  def execute
    
    if(@command.nil?)
      @command = get_msdeploy_path
    end

    cmd_params = []
    cmd_params << get_package
    cmd_params << get_destination
    cmd_params << get_parameters
    cmd_params << get_constant_parameters
    
    if(!@additional_parameters.nil?)
      cmd_params << @additional_parameters
    end
    cmd_params << get_whatif

    result = run_command "MSDeploy Command", "#{cmd_params.join(" ")}"
  
    failure_msg = 'MSDeploy Failed.  See build log for details'
    fail_with_message failure_msg if !result
    end
  
  def get_msdeploy_path
    
    #check path directory
    ENV['PATH'].split(';').each do |folder| 
      if(File.exists?(folder+'/msdeploy.exe'))
        return folder+'/msdeploy.exe'
      end      
    end    
    #check if it's in registry
    msdeploy_path = ENV['MSDeployPath']    
    if(msdeploy_path == nil || !File.exist?("#{msdeploy_path}msdeploy.exe"))      
      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\IIS Extensions\MSDeploy\2') do |reg|
          reg_typ, reg_val = reg.read('InstallPath') # no checking for x86 here.
          msdeploy_path = reg_val
        end     
   end
   fail_with_message 'MSDeploy could not be found is it installed?' if !File.exist?("#{msdeploy_path}msdeploy.exe")
   return "#{msdeploy_path}msdeploy.exe"    
 end
 
 def get_package
   #is it a direct file
   if(File.file?(@deploy_package))
     return "-source:package='#{File.expand_path(@deploy_package)}'"
   end
   
   #try directory with zip in it
   Dir.glob("#{@deploy_package}/**.zip") do |zip|
     puts File.expand_path(zip)
     return "-source:package='#{File.expand_path(zip)}'"
   end
   # must be an archive directory
   package_location = "#{@deploy_package}/archive"
   if(File.exists?(package_location))
     return "-source:archiveDir='#{File.expand_path(package_location)}'"
   end
   fail_with_message "Could not find the MSDeploy package to deploy."
 end

def get_destination
  if(@server.nil?)
    #no server so use auto
    return "-dest:auto,includeAcls='False'"
  end
  destination_string = "-dest:auto,computerName='#{@server}'"
  if(!@username.nil?)
    destination_string  << ",userName='#{@username}'"
  end
  if(!@password.nil?)
     destination_string  << ",password='#{@password}'"
   end
   return destination_string << ",includeAcls='False'"
end

 def get_parameters
   if (!@parameters_file.nil?)
      Dir.glob("#{@parameters_file}") do |parameters| 
        return "-setParamFile:\"#{File.expand_path(parameters)}\""
      end 
      fail_with_message 'Could not find parameter file specified.'
    else
      Dir.glob("#{@deploy_package}/**.SetParameters.xml") do |parameters| 
        return "-setParamFile:\"#{File.expand_path(parameters)}\""
      end
    end
    return nil  
  end
  
 def get_whatif
   if(@noop)
     return "-whatif"
   end
 end
 
 def get_constant_parameters
   return "-verb:sync  -disableLink:AppPoolExtension  -disableLink:ContentExtension  -disableLink:CertificateExtension "
 end
end
