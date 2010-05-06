create_task :unzip, Proc.new { Unzip.new } do |zip|
  zip.unzip
end
