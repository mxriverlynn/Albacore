create_task :ssh, Ssh.new do |cmd|
  cmd.execute
end
