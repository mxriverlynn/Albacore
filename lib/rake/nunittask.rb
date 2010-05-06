create_task :nunit, Proc.new { NUnitTestRunner.new } do |n|
  n.execute
end    
