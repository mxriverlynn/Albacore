create_task :sqlcmd, Proc.new { SQLCmd.new } do |cmd|
  cmd.run
end
