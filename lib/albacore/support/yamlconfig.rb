require 'yaml'

module YAMLConfig  
  def initialize
    configure_if_config_exists(self.class.to_s.downcase)
    super()
  end
  
  def YAMLConfig.extend_object(obj)
    obj.configure_if_config_exists(obj.class.to_s.downcase)
  end
  
  def configure_if_config_exists(task_name)
    task_config = task_name + '.yml'
    task_config = File.join(Albacore::yaml_config_folder, task_config) unless Albacore::yaml_config_folder.nil?
    puts "----------- YAML CONFIG: #{task_config}"
    puts "----------- YAML CONFIG EXISTS: #{File.exists?(task_config)}"
    configure(task_config) if File.exists?(task_config)
  end
  
  def configure(yml_file)
    config = YAML::load(File.open(yml_file))
    parse_config config
  end  
  
  def parse_config(config)
    config.each do |key, value|
      setter = "#{key}="
      self.class.send(:attr_accessor, key) if !respond_to?(setter)
      send setter, value
    end
  end
end
