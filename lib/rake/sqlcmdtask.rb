create_task :sqlcmd, SQLCmd.new do |cmd|
  cmd.run
  fail if cmd.failed
end