create_task :docu, Docu.new do |doc|
  doc.execute
  fail if doc.failed
end
