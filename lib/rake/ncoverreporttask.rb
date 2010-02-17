create_task :ncoverreport do |name|
  ncoverreport = NCoverReport.new
  ncoverreport.load_config_by_task_name(name)
  call_task_block(ncoverreport)
  ncoverreport.run
  fail if ncoverreport.failed
end