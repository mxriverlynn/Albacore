create_task :csc, Proc.new { CSC.new } do |csharp|
  csharp.execute
end
