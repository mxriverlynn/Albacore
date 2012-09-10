require 'spec_helper'
require 'ziptestdata'
require 'albacore/zipdirectory'
require 'albacore/unzip'

describe Unzip, "when providing configuration" do
  let :uz do
    Albacore.configure do |config|
      config.unzip.file = "configured"
      config.unzip.force = true
    end
    uz = Unzip.new
  end

  it "should use the configured values" do
    uz.file.should == "configured"
  end
  
  it "should set the force option to true" do
    uz.force.should be_true
  end
end

describe Unzip, 'when unzipping a file that already exists without force option set' do
  before :each do
    zip = ZipDirectory.new
    zip.directories_to_zip ZipTestData.folder
    zip.output_file = 'test.zip'
    zip.execute
    
    unzip = Unzip.new
    unzip.file = File.join(ZipTestData.folder, 'test.zip')
    unzip.destination = ZipTestData.output_folder
    unzip.execute	
  end
  
  after :each do
    FileUtils.rm_rf ZipTestData.output_folder if File.exist? ZipTestData.output_folder
  end
  
  it 'should not unzip the file' do  
	new_text = "Test file for unzip task"
  	changed_file = File.join(ZipTestData.output_folder, 'files', 'testfile.txt')
	File.open(changed_file, 'a') { |f| f.write(new_text) }
	
    unzip = Unzip.new
    unzip.file = File.join(ZipTestData.folder, 'test.zip')
    unzip.destination = ZipTestData.output_folder
	unzip.force = false
    unzip.execute	

    File.exist?(changed_file).should be_true
	File.open(changed_file).grep(/#{new_text}/).count.should be > 0
  end
end

describe Unzip, 'when unzipping a file that already exists with force option set' do
  before :each do
    zip = ZipDirectory.new
    zip.directories_to_zip ZipTestData.folder
    zip.output_file = 'test.zip'
    zip.execute
    
    unzip = Unzip.new
    unzip.file = File.join(ZipTestData.folder, 'test.zip')
    unzip.destination = ZipTestData.output_folder
    unzip.execute	
  end
  
  after :each do
    FileUtils.rm_rf ZipTestData.output_folder if File.exist? ZipTestData.output_folder
  end
  
  it 'should unzip the file' do
	new_text = "Test file for unzip task"
  	changed_file = File.join(ZipTestData.output_folder, 'files', 'testfile.txt')
	File.open(changed_file, 'a') { |f| f.write(new_text) }

    unzip = Unzip.new
    unzip.file = File.join(ZipTestData.folder, 'test.zip')
    unzip.destination = ZipTestData.output_folder
	unzip.force = true
    unzip.execute	

    File.exist?(changed_file).should be_true
	File.open(changed_file).grep(/#{new_text}/).count.should be == 0
  end
end
