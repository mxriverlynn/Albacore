create_task :plink, PLink.new() do |cmd|
  cmd.run
  fail if cmd.failed
end  
