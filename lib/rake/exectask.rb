create_task :exec, Exec.new do |ex|
  ex.execute
  fail if ex.failed
end