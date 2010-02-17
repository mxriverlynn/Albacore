create_task :assemblyinfo do |name|
  asm = AssemblyInfo.new
  asm.load_config_by_task_name(name)
  call_task_block(asm)
  asm.write
  fail if asm.failed
end
