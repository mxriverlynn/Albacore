create_task :zip, Proc.new { ZipDirectory.new } do |z|
  z.package
end
