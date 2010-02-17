create_task :ndepend, NDepend.new do |cmd|
  cmd.run
  fail if cmd.failed
end