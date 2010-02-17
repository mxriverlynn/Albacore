create_task :nunit, NUnitTestRunner.new do |n|
  n.execute
  fail if n.failed
end    
