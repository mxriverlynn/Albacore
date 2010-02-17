create_task :nunit do |name|
  nunit = NUnitTestRunner.new
  nunit.load_config_by_task_name(name)
  call_task_block(nunit)
  nunit.execute
  fail if nunit.failed
end    
