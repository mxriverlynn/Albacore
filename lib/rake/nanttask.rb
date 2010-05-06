create_task :nant, Proc.new { NAnt.new } do |nant|
  nant.run
end
