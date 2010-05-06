create_task :ndepend, Proc.new { NDepend.new } do |cmd|
  cmd.run
end
