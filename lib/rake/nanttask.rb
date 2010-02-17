create_task :nant, NAnt.new do |nant|
  nant.run
  fail if nant.failed
end
