create_task :ncoverconsole, NCoverConsole.new do |ncover|
  ncover.run
  fail if ncover.failed
end  
