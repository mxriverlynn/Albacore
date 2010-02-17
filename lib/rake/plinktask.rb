create_task :plink do |name|
  cmd = PLink.new()
  cmd.load_config_by_task_name(name)
  call_task_block(cmd)
  cmd.run
  fail if cmd.failed
end  
