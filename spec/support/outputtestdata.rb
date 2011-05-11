class OutputTestData
  
  @@from = File.expand_path(File.join(File.dirname(__FILE__), 'src'))
  @@to = File.expand_path(File.join(File.dirname(__FILE__), 'out'))
  
  def self.from
    @@from
  end
  
  def self.to
    @@to
  end
end