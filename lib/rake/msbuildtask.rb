create_task :msbuild do |name|
  msbuild = MSBuild.new
  msbuild.load_config_by_task_name(name)
  call_task_block(msbuild)
  msbuild.build
  fail if msbuild.failed
end
