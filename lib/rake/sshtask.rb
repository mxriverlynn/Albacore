create_task :ssh, Proc.new { Ssh.new } do |cmd|
  cmd.execute
end
