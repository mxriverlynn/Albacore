class CopyDirTestData
  
  @@folder = File.expand_path(File.join(File.dirname(__FILE__), 'copy_src'))
  @@output_folder = File.expand_path(File.join(File.dirname(__FILE__), 'copy_dest'))
  
  def self.folder
    @@folder
  end
  
  def self.output_folder
    @@output_folder
  end
end