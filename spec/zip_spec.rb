require File.join(File.expand_path(File.dirname(__FILE__)), 'support', 'spec_helper')
require 'zipdirectory'
require 'ziptestdata'

describe ZipDirectory, 'when zipping a directory of files' do
	before :each do
		zip = ZipDirectory.new
		puts "#{ZipTestData.folder}"
		zip.directory_to_zip = ZipTestData.folder
		zip.file = "test.zip"
		zip.package
	end
	
	it "should prodice a zip file" do
		File.exist?(File.join(ZipTestData.folder, "test.zip")).should be_true
	end
end

