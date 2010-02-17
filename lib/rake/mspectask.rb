create_task :mspec, MSpecTestRunner.new do |mspec|
  mspec.execute
  fail if mspec.failed
end