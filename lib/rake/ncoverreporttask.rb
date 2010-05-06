create_task :ncoverreport, Proc.new { NCoverReport.new } do |ncoverreport|
  ncoverreport.run
end
