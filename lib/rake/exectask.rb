create_task :exec do |name|
  @exec = Exec.new
  @exec.load_config_by_task_name(name)
  call_task_block(@exec)
  @exec.execute
  fail if @exec.failed
end