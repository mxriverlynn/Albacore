class ZipTestData
  
  @@folder = File.expand_path(File.join(File.dirname(__FILE__), 'zip'))
  @@output_folder = File.expand_path(File.join(File.dirname(__FILE__), 'zip_output'))
  
  def self.folder
    @@folder
  end
  
  def self.output_folder
    @@output_folder
  end
end