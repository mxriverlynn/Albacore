create_task :nant do |name|
  nant = NAnt.new
  nant.load_config_by_task_name(name)
  call_task_block(nant)
  nant.run
  fail if nant.failed
end
