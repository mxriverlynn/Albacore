require 'albacore/support/albacore_helper'
require 'zip/zip'
require 'zip/zipfilesystem'
include Zip

class ZipDirectory
	include YAMLConfig
	
	attr_accessor :directory_to_zip
	attr_accessor :additional_files
	attr_accessor :file

	def initialize
		super()
	end
		
	def package()
		return if @directory_to_zip.nil?
		
		@directory_to_zip.sub!(%r[/$],'')
		remove zip_name

		ZipFile.open(zip_name, 'w')	do |zipfile|
			zip_directory(zipfile)
			zip_additional(zipfile)
		end
	end
	
	def remove(filename)
		FileUtils.rm filename, :force=>true
	end
	
	def reject_file(f)
		f == zip_name
	end
	
	def zip_name()
		File.join(@directory_to_zip, @file)
	end
	
	def zip_directory(zipfile)
		Dir["#{@directory_to_zip}/**/**"].reject{|f| reject_file(f)}.each do |file_path|
			file_name = file_path.sub(@directory_to_zip+'/','');
			zipfile.add(file_name, file_path)
		end
	end
	
	def zip_additional(zipfile)
		return if @additional_files.nil?
		@additional_files.reject{|f| reject_file(f)}.each do |file_path|
			file_name = file_path#.split('/').last
			zipfile.add(file_name, file_path)
		end
	end
end