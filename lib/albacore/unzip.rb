require 'albacore/support/albacore_helper'
require 'zip/zip'
require 'zip/zipfilesystem'
include Zip

class Unzip
  include YAMLConfig
  include Failure
  
  attr_accessor :unzip_path, :zip_file

  def initialize
    super()
  end
    
  def unzip()
    fail_with_message 'Zip File cannot be empty' if @zip_file.nil?
    return if @zip_file.nil?
  
    Zip::ZipFile.open(@zip_file) do |zip_file|
        zip_file.each do |file|
           out_path = File.join(@unzip_path, file.name)
           FileUtils.mkdir_p(File.dirname(out_path))
           zip_file.extract(file, out_path) unless File.exist?(out_path)
        end
      end
  end
end