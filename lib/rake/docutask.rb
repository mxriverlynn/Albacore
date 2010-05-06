create_task :docu, Proc.new { Docu.new } do |doc|
  doc.execute
end
