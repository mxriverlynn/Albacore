create_task :xunit, Proc.new { XUnitTestRunner.new } do |x|
  x.execute
end
