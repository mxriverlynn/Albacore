require 'albacore/support/albacore_helper'
require 'zip/zip'
require 'zip/zipfilesystem'
include Zip

class ZipDirectory
	include YAMLConfig
	
	attr_accessor :directories_to_zip
	attr_accessor :output_path
	attr_accessor :additional_files
	attr_accessor :file

	def initialize
		super()
	end
		
	def package()
		return if @directories_to_zip.nil?
		
		clean_directories_names
		remove zip_name

		ZipFile.open(zip_name, 'w')	do |zipfile|
			zip_directory(zipfile)
			zip_additional(zipfile)
		end
	end
	
	def clean_directories_names
	  @directories_to_zip.each { |d| d.sub!(%r[/$],'')}
	end
	
	def remove(filename)
		FileUtils.rm filename, :force=>true
	end
	
	def reject_file(f)
		f == zip_name
	end
	
	def zip_name()
	  @output_path = @directories_to_zip.first unless @output_path
		File.join(@output_path, @file)
	end
	
	def zip_directory(zipfile)
	  @directories_to_zip.each do |d|
  		Dir["#{d}/**/**"].reject{|f| reject_file(f)}.each do |file_path|
        file_name = file_path
  			file_name = file_path.sub(d + '/','') if @directories_to_zip.length == 1
  			zipfile.add(file_name, file_path)
  		end
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