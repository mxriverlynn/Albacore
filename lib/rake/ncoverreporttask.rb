create_task :ncoverreport, NCoverReport.new do |ncoverreport|
  ncoverreport.run
  fail if ncoverreport.failed
end