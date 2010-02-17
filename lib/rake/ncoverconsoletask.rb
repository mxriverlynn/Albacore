create_task :ncoverconsole do |name|
  ncover = NCoverConsole.new
  ncover.load_config_by_task_name(name)
  call_task_block(ncover)
  ncover.run
  fail if ncover.failed
end  
