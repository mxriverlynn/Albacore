create_task :assemblyinfo, Proc.new { AssemblyInfo.new } do |asm|
  asm.write
end
