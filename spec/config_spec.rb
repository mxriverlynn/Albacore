require File.join(File.dirname(__FILE__), 'support', 'spec_helper')

describe "when adding a new path with a supplied name" do
  before :each do
    Albacore.configure do |config|
      config.add_path :path_name, "./whatever/"
    end
  end
  
  it "should make the path available by the supplied name" do
    Albacore.configuration.get_path(:path_name).should == "./whatever/"
  end
end

describe "when specifying a path for a name that already exists" do
  before :each do
    Albacore.configure do |config|
      config.add_path :path, "foo/bar"
      config.add_path :path, "widget"
    end
  end

  it "should overwrite the previous path" do
    Albacore.configuration.get_path(:path).should == "widget"
  end
end

describe "when retrieving a path that does not exist" do
  it "should return nil" do 
    Albacore.configuration.get_path(:doesnotexist).should == nil
  end
end
