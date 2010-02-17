create_task :msbuild, MSBuild.new do |msbuild|
  msbuild.build
  fail if msbuild.failed
end
