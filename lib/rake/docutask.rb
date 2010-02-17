create_task :docu do |name|
  doc = Docu.new
  doc.load_config_by_task_name(name)
  call_task_block(doc)
  doc.execute
  fail if doc.failed
end
