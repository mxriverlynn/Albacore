create_task :plink, Proc.new { PLink.new() } do |cmd|
  cmd.run
end  
