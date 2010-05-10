create_task :csc, Proc.new { CSC.new } do |csharp|
  csharp.build
end
