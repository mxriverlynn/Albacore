create_task :xbuild, XBuild.new do |xb|
  xb.build
  fail if xb.failed
end

create_task :mono, XBuild.new do |xb|
  xb.build
  fail if xb.failed
end
