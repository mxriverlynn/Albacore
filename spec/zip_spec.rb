require 'spec_helper'
require 'albacore/zipdirectory'
require 'albacore/unzip'
require 'ziptestdata'

describe ZipDirectory, 'when zipping a directory of files' do
  before :each do
    zip = ZipDirectory.new
    zip.directories_to_zip ZipTestData.folder
    zip.output_file = "test.zip"
    zip.execute
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
    zip.exclusions File.join(ZipTestData.folder, 'files', 'testfile.txt')
    zip.execute
    
    unzip = Unzip.new
    unzip.file = File.join(ZipTestData.folder, 'test.zip')
    unzip.destination = ZipTestData.output_folder
    unzip.execute
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
    zip.execute
    
    unzip = Unzip.new
    unzip.file = File.join(ZipTestData.folder, 'test.zip')
    unzip.destination = ZipTestData.output_folder
    unzip.execute
  end
  
  after :each do
    FileUtils.rm_rf ZipTestData.output_folder if File.exist? ZipTestData.output_folder
  end
  
  it 'should not zip files that match any of the exclusions regexps' do
    File.exist?(File.join(ZipTestData.output_folder, 'files', 'testfile.txt')).should be_false
  end
end

describe ZipDirectory, 'when zipping a directory of files with glob string exclusions' do
  before :each do
    zip = ZipDirectory.new
    zip.directories_to_zip ZipTestData.folder
    zip.output_file = 'test.zip'
    zip.exclusions "**/subfolder/*"
    zip.execute

    unzip = Unzip.new
    unzip.file = File.join(ZipTestData.folder, 'test.zip')
    unzip.destination = ZipTestData.output_folder
    unzip.execute
  end

  after :each do
    FileUtils.rm_rf ZipTestData.output_folder if File.exists? ZipTestData.output_folder
  end

  it 'should not zip files that match the expanded globs' do
    File.exist?(File.join(ZipTestData.output_folder, 'files', 'subfolder', 'sub file.txt')).should be_false
  end

  it 'should zip the files that don\'t match the globs' do
    File.exist?(File.join(ZipTestData.output_folder, 'files', 'subfolder')).should be_true
    File.exist?(File.join(ZipTestData.output_folder, 'files', 'testfile.txt')).should be_true
  end
end

describe ZipDirectory, "when providing configuration" do
  let :zip do
    Albacore.configure do |config|
      config.zip.output_file = "configured"
    end
    zip = ZipDirectory.new
  end

  it "should use the configured values" do
    zip.output_file.should == "configured"
  end
end

describe ZipDirectory, 'when zipping a directory of files with additional files' do
  describe 'and additional file is given as an array' do
    before :each do
      zip = ZipDirectory.new
      zip.directories_to_zip ZipTestData.folder
      zip.output_file = 'test.zip'
      zip.exclusions "**/subfolder/*"
      zip.additional_files = [File.join(File.dirname(__FILE__), 'support', 'test.yml')]
      zip.execute
      
      unzip = Unzip.new
      unzip.file = File.join(ZipTestData.folder, 'test.zip')
      unzip.destination = ZipTestData.output_folder
      unzip.execute
    end

    after :each do
      FileUtils.rm_rf ZipTestData.output_folder if File.exist? ZipTestData.output_folder
    end

    it "should add additional file" do
      File.exist?(File.join(ZipTestData.folder, "test.zip")).should be_true
      File.exist?(File.join(ZipTestData.output_folder, 'files', 'subfolder')).should be_true
      File.exist?(File.join(ZipTestData.output_folder, 'files', 'testfile.txt')).should be_true
      File.exist?(File.join(ZipTestData.output_folder, 'test.yml')).should be_true
    end
  end
  
  describe 'and additional file is given as a string' do
    before :each do
      zip = ZipDirectory.new
      zip.directories_to_zip ZipTestData.folder
      zip.output_file = 'test.zip'
      zip.exclusions "**/subfolder/*"
      zip.additional_files = File.join(File.dirname(__FILE__), 'support', 'test.yml')
      zip.execute
      
      unzip = Unzip.new
      unzip.file = File.join(ZipTestData.folder, 'test.zip')
      unzip.destination = ZipTestData.output_folder
      unzip.execute
    end

    after :each do
      FileUtils.rm_rf ZipTestData.output_folder if File.exist? ZipTestData.output_folder
    end
    
    it "should add additional file" do
      File.exist?(File.join(ZipTestData.folder, "test.zip")).should be_true
      File.exist?(File.join(ZipTestData.output_folder, 'files', 'subfolder')).should be_true
      File.exist?(File.join(ZipTestData.output_folder, 'files', 'testfile.txt')).should be_true
      File.exist?(File.join(ZipTestData.output_folder, 'test.yml')).should be_true
    end
  end
end
