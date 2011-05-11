require 'spec_helper'
require 'outputtestdata'
describe Output, 'when having a from and to set' do 

      before :each do
        FileUtils.mkdir(OutputTestData.from) unless File.exists? OutputTestData.from
        
        @o = Output.new
        @o.from OutputTestData.from
        @o.to OutputTestData.to
        
      end
      after :each do
        FileUtils.rm_rf OutputTestData.to if File.exists? OutputTestData.to
        FileUtils.rm_rf OutputTestData.from if File.exists? OutputTestData.from
      end
  
  
    describe 'and when outputting files' do
      before :each do
        File.open("#{OutputTestData.from}/test.txt", "w"){|f| f.write "test" }
      end
      
      it "should not output a file if not specified so" do
        @o.execute
       
        File.exist?("#{OutputTestData.to}/test.txt").should be_false
      end
      
      it "should output a file specified" do
        @o.file 'test.txt'
        @o.execute
       
        File.exist?("#{OutputTestData.to}/test.txt").should be_true
      end
    end
    
    
    describe 'and when outputting directories' do
      before :each do
        subdir = "#{OutputTestData.from}/subdir"
        FileUtils.mkdir(subdir) unless File.exists? subdir
        File.open("#{OutputTestData.from}/subdir/test.txt", "w"){|f| f.write "test_sub" }
      end
      
      it "should not output a directory if not specified so" do
        @o.execute
       
        File.exist?("#{OutputTestData.to}/subdir").should be_false
      end
      
      it "should output a directory and content if specified" do
        @o.dir 'subdir'
        @o.execute
       
        File.exist?("#{OutputTestData.to}/subdir").should be_true
        File.exist?("#{OutputTestData.to}/subdir/test.txt").should be_true
      end
    end
    
    describe 'and when outputting nested directories' do
      before :each do
        subdir = "#{OutputTestData.from}/subdir/foo"
        FileUtils.mkdir_p(subdir) unless File.exists? subdir
        File.open("#{OutputTestData.from}/subdir/foo/test.txt", "w"){|f| f.write "test_sub" }
      end
      
      it "should not output a directory if not specified so" do
        @o.execute
       
        File.exist?("#{OutputTestData.to}/subdir/foo").should be_false
      end
      
      it "should output a directory and content if specified" do
        @o.dir 'subdir'
        @o.execute
       
        File.exist?("#{OutputTestData.to}/subdir/foo").should be_true
        File.exist?("#{OutputTestData.to}/subdir/foo/test.txt").should be_true
      end
    end
    
    
    describe 'and when outputting files with renaming them at target' do
      before :each do
        subdir = "#{OutputTestData.from}/subdir/foo"
        FileUtils.mkdir_p(subdir) unless File.exists? subdir
        File.open("#{OutputTestData.from}/subdir/foo/test.txt", "w"){|f| f.write "test_sub" }
      end
      
      it "should rename and create entire path if nested deeply" do
        @o.file 'subdir/foo/test.txt', :as => 'subdir/foo/hello.txt'
        @o.execute
       
        File.exist?("#{OutputTestData.to}/subdir/foo").should be_true
        File.exist?("#{OutputTestData.to}/subdir/foo/hello.txt").should be_true
        File.exist?("#{OutputTestData.to}/subdir/foo/test.txt").should be_false
      end
    end
    
    describe 'and when using erb, should have templated output' do
      before :each do
        subdir = "#{OutputTestData.from}/subdir/foo"
        FileUtils.mkdir_p(subdir) unless File.exists? subdir
        File.open("#{OutputTestData.from}/subdir/foo/web.config.erb", "w"){|f| f.write "test_sub <%= my_value %>" }
      end
      
      it "should rename and create entire path if nested deeply" do
        @o.erb 'subdir/foo/web.config.erb', :as => 'subdir/foo/web.config', :locals => { :my_value => 'hello' }
        @o.execute
        
        File.exist?("#{OutputTestData.to}/subdir/foo").should be_true
        File.exist?("#{OutputTestData.to}/subdir/foo/web.config").should be_true
        File.read("#{OutputTestData.to}/subdir/foo/web.config").should == "test_sub hello"
      end
    end
end
