require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/support/attrmethods'

describe "when setting an array attribute value without the equal sign" do
  before :each do 
   class Test_Class
     extend AttrMethods
     attr_array :test
   end 

   @test = Test_Class.new
   @test.test 1, 2, 3, 4
  end

  it "should set the array to the specified values" do
    @test.test.length.should be(4)
  end
end

describe "when setting an array attribute with a params list, using the equal sign" do
  before :each do
    class Test_Class
      extend AttrMethods
      attr_array :test
    end

    @test = Test_Class.new
    @test.test = 1, 2, 3, 4
  end

  it "should set the array to the specified values" do
    @test.test.length.should be(4)
  end
end

describe "when setting an array attribute to an array variable using the equal sign" do
  before :each do
    class TestClass
      extend AttrMethods
      attr_array :test
    end

    test_values = [1, 2, 3, 4, 5]
    @test = TestClass.new
    @test.test = test_values 
  end

  it "should set the array to the values contained in the variable" do
    @test.test.length.should be(5)
  end
end

describe "when setting a hash attribute value without the equal sign" do
  before :each do 
   class Test_Class
     extend AttrMethods
     attr_hash :test
   end 

   @test = Test_Class.new
   @test.test "a" => "b", "c" => "d"
  end

  it "should set the hash to the specified values" do
    @test.test.length.should be(2)
  end
end

describe "when setting a hash attribute with a params list, using the equal sign" do
  before :each do
    class Test_Class
      extend AttrMethods
      attr_hash :test
    end

    @test = Test_Class.new
    @test.test = {"a" => "b", "c" => "d"}
  end

  it "should set the hash to the specified values" do
    @test.test.length.should be(2)
  end
end

describe "when setting a hash attribute to an array variable using the equal sign" do
  before :each do
    class TestClass
      extend AttrMethods
      attr_hash :test
    end

    test_values = {"a" => "b", "c" => "d", "e" => "f"}
    @test = TestClass.new
    @test.test = test_values 
  end

  it "should set the hash to the values contained in the variable" do
    @test.test.length.should be(3)
  end
end
