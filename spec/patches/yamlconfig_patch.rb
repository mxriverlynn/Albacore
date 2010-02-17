module YAMLConfig
  attr_accessor :yamlconfig_name
  def load_config_by_task_name(task_name)
  	@yamlconfig_name = task_name
  end
end