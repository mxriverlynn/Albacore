create_task :mspec do |name|
  mspec = MSpecTestRunner.new
  mspec.load_config_by_task_name(name)
  call_task_block(mspec)
  mspec.execute
  fail if mspec.failed
end