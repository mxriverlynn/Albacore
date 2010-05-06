create_task :mspec, Proc.new { MSpecTestRunner.new } do |mspec|
  mspec.execute
end
