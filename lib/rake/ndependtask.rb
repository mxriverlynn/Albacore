create_task :ndepend do |name|
  cmd = NDepend.new()
  cmd.load_config_by_task_name(name)
  call_task_block(cmd)
  cmd.run
  fail if cmd.failed
end