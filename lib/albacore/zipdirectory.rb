require 'zip/zip'
require 'zip/zipfilesystem'
include Zip

class ZipDirectory
	attr_accessor :path
	attr_accessor :file
		
	def package()
		@path.sub!(%r[/$],'')
		remove zip_name

		ZipFile.open(zip_name, 'w') do |zipfile|
			zip_directory(zipfile)
		end
	end
	
	def remove(filename)
		FileUtils.rm filename, :force=>true
	end
	
	def reject_file(f)
		f == zip_name
	end
	
	def zip_name()
		File.join(@path, @file)
	end
	
	def zip_directory(zipfile)
		Dir["#{@path}/**/**"].reject{|f| reject_file(f)}.each do |file_path|
			file_name = file_path.sub(@path+'/','');
			zipfile.add(file_name, file_path)
		end
	end
end