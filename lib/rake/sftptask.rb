create_task :sftp, Proc.new { Sftp.new } do |cmd|
  cmd.upload
end
