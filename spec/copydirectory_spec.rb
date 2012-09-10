require 'spec_helper'
require 'albacore/copydirectory'
require 'copydirectorytestdata'

describe CopyDir, "When asked to copy directory recursively" do
  before :each do
    @cdir = CopyDir.new
    @cdir.src = CopyDirTestData.folder
    @cdir.dest = CopyDirTestData.output_folder
	@cdir.delete_dest = true    
  end
  
  after :each do
    FileUtils.rm_rf CopyDirTestData.output_folder if File.exist? CopyDirTestData.output_folder
  end
  
  it "should copy the directory and exclude files" do	
	@cdir.exclude = ['testfile.txt']
	@cdir.execute
	File.exist?(File.join(CopyDirTestData.output_folder, 'files', 'testfile.txt')).should be_false
  end  
  
  it "should copy the directory" do
	@cdir.execute
	File.exist?(File.join(CopyDirTestData.output_folder, 'files', 'testfile.txt')).should be_true
  end  
end