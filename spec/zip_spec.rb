require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/zipdirectory'
require 'ziptestdata'

describe ZipDirectory, 'when zipping a directory of files' do
	before :each do
		zip = ZipDirectory.new
		puts "#{ZipTestData.folder}"
		zip.directories_to_zip = [ZipTestData.folder]
		zip.output_file = "test.zip"
		zip.package
	end
	
	it "should produce a zip file" do
		File.exist?(File.join(ZipTestData.folder, "test.zip")).should be_true
	end
end

