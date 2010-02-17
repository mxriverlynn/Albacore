create_task :unzip, Unzip.new do |zip|
  zip.unzip
  fail if zip.failed
end