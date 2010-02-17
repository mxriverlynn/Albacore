create_task :expandtemplates do |name|
  exp = ExpandTemplates.new
  exp.load_config_by_task_name(name)
  call_task_block(exp)
  exp.expand
end