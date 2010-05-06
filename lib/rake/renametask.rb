create_task :rename, Proc.new { Renamer.new } do |ren|
  ren.rename
end
