create_task :xbuild, XBuild.new do |xb|
  xb.build
end

create_task :mono, XBuild.new do |xb|
  xb.build
end
