create_task :specflow, Proc.new { SpecFlowRunner.new } do |spec|
  spec.execute
end
