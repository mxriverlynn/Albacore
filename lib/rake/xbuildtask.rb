create_task :xbuild, Proc.new { XBuild.new } do |xb|
  xb.build
end

create_task :mono, Proc.new { XBuild.new } do |xb|
  xb.build
end
