create_task :assemblyinfo, AssemblyInfo.new do |asm|
  asm.write
  fail if asm.failed
end
