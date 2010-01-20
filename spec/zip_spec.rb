require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/zipdirectory'
require 'albacore/unzip'
require 'ziptestdata'

describe ZipDirectory, 'when zipping a directory of files' do
  before :each do
    zip = ZipDirectory.new
    zip.directories_to_zip ZipTestData.folder
    zip.output_file = "test.zip"
    zip.package
  end
  
  it "should produce a zip file" do
    File.exist?(File.join(ZipTestData.folder, "test.zip")).should be_true
  end
end

describe ZipDirectory, 'when zipping a directory with string exclusions' do
  before :each do
    zip = ZipDirectory.new
    zip.directories_to_zip ZipTestData.folder
    zip.output_file = 'test.zip'
    zip.exclusions File.expand_path(File.join(ZipTestData.folder, 'files', 'testfile.txt'))
    zip.package
    
    unzip = Unzip.new
    unzip.zip_file = File.join(ZipTestData.folder, 'test.zip')
    unzip.unzip_path = ZipTestData.output_folder
    unzip.unzip
  end
  
  after :each do
    FileUtils.rm_rf ZipTestData.output_folder if File.exist? ZipTestData.output_folder
  end
  
  it 'should not zip files with the same name as any exclusions' do
    File.exist?(File.join(ZipTestData.output_folder, 'files', 'testfile.txt')).should be_false
  end
end

describe ZipDirectory, 'when zipping a directory of files with regexp exclusions' do
before :each do
    zip = ZipDirectory.new
    zip.directories_to_zip ZipTestData.folder
    zip.output_file = 'test.zip'
    zip.exclusions /testfile/
    zip.package
    
    unzip = Unzip.new
    unzip.zip_file = File.join(ZipTestData.folder, 'test.zip')
    unzip.unzip_path = ZipTestData.output_folder
    unzip.unzip
  end
  
  after :each do
    FileUtils.rm_rf ZipTestData.output_folder if File.exist? ZipTestData.output_folder
  end
  
  it 'should not zip files that match any of the exclusions regexps' do
    File.exist?(File.join(ZipTestData.output_folder, 'files', 'testfile.txt')).should be_false
  end
end