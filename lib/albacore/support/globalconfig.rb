module Albacore
  @@yaml_config_folder = nil
  
  def Albacore.yaml_config_folder=(folder)
  	@@yaml_config_folder = folder
  end
  
  def Albacore.yaml_config_folder
  	@@yaml_config_folder
  end
end