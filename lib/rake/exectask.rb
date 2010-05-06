create_task :exec, Proc.new { Exec.new } do |ex|
  ex.execute
end
