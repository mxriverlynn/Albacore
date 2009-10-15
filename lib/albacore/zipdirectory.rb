require 'zip/zip'
require 'zip/zipfilesystem'

class ZipDirectory
	attr_accessor :path
	attr_accessor :file
		
	def package()
		@path.sub!(%r[/$],'')
		archive = File.join(@path, @file)
		FileUtils.rm archive, :force=>true

		Zip::ZipFile.open(archive, 'w') do |zipfile|
			Dir["#{@path}/**/**"].reject{|f|f==archive}.each do |file|
				zipfile.add(file.sub(@path+'/',''),file)
			end
		end
	end
end