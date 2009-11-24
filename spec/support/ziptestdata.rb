class ZipTestData
	
	@@folder = File.expand_path(File.join(File.dirname(__FILE__), 'zip'))
	
	def self.folder
		@@folder
	end
end