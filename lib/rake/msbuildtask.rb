create_task :msbuild, Proc.new { MSBuild.new } do |msbuild|
  msbuild.build
end
