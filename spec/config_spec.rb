require File.join(File.dirname(__FILE__), 'support', 'spec_helper')

describe "when adding a new path with a supplied name" do
  before :each do
    Albacore.configure do |config|
      config.add_path :path_name, "./whatever/"
    end
  end
  
  it "should make the path available by the supplied name" do
    Albacore.configuration.get_path :path_name
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

describe "when requesting the command for a task" do
  before :each do
    Albacore.configure do |config|
      config.sometask "some/dir", "command.exe"
    end
  end

  it "should provide the appended path and command" do
    Albacore.configuration.get_command(:sometask).should == "some/dir/command.exe"
  end
end

describe "when requesting the command for a task that was configured with a named path" do
  before :each do
    Albacore.configure do |config|
      config.add_path :path, "what/ever"
      config.mytask :path, "my.exe"
    end
  end

  it "should evaluate the path by the name and append the path and command" do
    Albacore.configuration.get_command(:mytask).should == "what/ever/my.exe"
  end
end

describe "when requesting the command for a task that has not been registered" do
  before :each do
    begin
      Albacore.configuration.get_command :has_not_been_configured
    rescue
      @error_message = $!
    end
  end
  
  it "should fail saying the task is not configured" do
    @error_message.to_s.should == "The 'has_not_been_configured' task has not been configured"
  end
end

describe "when registering a task with only a command parameter" do
  before :each do
    Albacore.configure do |config|
      config.oneparam "one/parameter.exe"
    end
  end

  it "should use the command parameter as the path and command" do
    Albacore.configuration.get_command(:oneparam).should == "one/parameter.exe"
  end
end

describe "when providing a configuration method to the configuration api" do
  before :all do
    class Test
      attr_accessor :test
    end

    Albacore.configure do |config|
      @configdata = Test.new
      config.add_configuration :testfoo, @configdata
    end

    Albacore.configure do |config|
      config.testfoo do |test|
        test.test = "this is config data"
      end
    end
  end

  it "should accept a parameter for configuration data" do
    @configdata.test.should == "this is config data"
  end
end
