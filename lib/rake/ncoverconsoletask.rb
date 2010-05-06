create_task :ncoverconsole, Proc.new { NCoverConsole.new } do |ncover|
  ncover.run
end  
