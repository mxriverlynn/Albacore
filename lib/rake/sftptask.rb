create_task :sftp, Sftp.new do |cmd|
  cmd.upload
end