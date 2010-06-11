create_task :specflowreport, Proc.new { SpecFlowReport.new } do |spec|
  spec.execute
end
