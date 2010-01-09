require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/expandtemplates'
require 'expandtemplatestestdata'

shared_examples_for "prepping the sample templates" do
  before :all do
    @testdata = ExpandTemplatesTestData.new
    @testdata.prep_sample_templates
    
    @templates = ExpandTemplates.new
    @templates.log_level = :verbose
  end
end

describe ExpandTemplates, "when expanding a single value into multiple locations" do
  it_should_behave_like "prepping the sample templates"
  
  before :all do
    @templates.expand_files @testdata.multipleinstance_template_file => @testdata.multipleinstance_template_file
    @templates.data_file = @testdata.sample_data_file
    @templates.expand
    
    @output_file_data = @testdata.read_file(@testdata.multipleinstance_template_file)
  end
  
  it "should replace the first location" do
    @output_file_data.should include("first instance of 'the real value' is here.")
  end
  
  it "should replace the second location" do
    @output_file_data.should include("second instance of 'the real value' goes here.")
  end
end

describe ExpandTemplates, "when expanding multiples value into multiple locations" do
  it_should_behave_like "prepping the sample templates"
  
  before :all do
    @templates.expand_files @testdata.multiplevalues_template_file => @testdata.multiplevalues_output_file
    @templates.data_file = @testdata.multiplevalues_data_file
    @templates.expand
    
    @output_file_data = @testdata.read_file(@testdata.multiplevalues_output_file)
  end
  
  it "should replace the values" do
    @output_file_data.should include("this is a template file with multiple values")
  end
  
  it "should write to the specified output file" do
    File.exist?(@testdata.multiplevalues_output_file).should be_true
  end
end

describe ExpandTemplates, "when expanding a template file and specifying an output file" do
  it_should_behave_like "prepping the sample templates"
  
  before :all do
    @templates.expand_files @testdata.sample_template_file => @testdata.sample_output_file
    @templates.data_file = @testdata.sample_data_file
    @templates.expand
    
    @output_file_data = @testdata.read_file(@testdata.sample_output_file)
  end
  
  it "should replace the \#{value} placeholder with 'the real value'" do
    @output_file_data.should include("the real value")
  end
  
  it "should write to the specified output file" do
    File.exist?(@testdata.sample_output_file).should be_true
  end
end

describe ExpandTemplates, "when expanding multiple template files" do
  it_should_behave_like "prepping the sample templates"
  
  before :all do
    @templates.expand_files(
      @testdata.multipleinstance_template_file => @testdata.multipleinstance_template_file,
      @testdata.sample_template_file => @testdata.sample_output_file,
      @testdata.multiplevalues_template_file => @testdata.multiplevalues_output_file
    )
    
    @templates.data_file = @testdata.multitemplate_data_file
    @templates.expand
    
    @output_file_data = @testdata.read_file(@testdata.multipleinstance_template_file)
  end
  
  it "should expand the first template right onto itself" do
    @output_file_data.should include("first instance of 'the real value' is here.")
  end
  
  it "should expand the second template to the specified location" do
    File.exist?(@testdata.sample_output_file).should be_true
  end
end

describe ExpandTemplates, "when expanding template files and the data file contains entries for specific templates" do
  it_should_behave_like "prepping the sample templates"
  
  before :all do
    @templates.expand_files(
      @testdata.multipleinstance_template_file => @testdata.multipleinstance_template_file,
      @testdata.sample_template_file => @testdata.sample_output_file,
      @testdata.multiplevalues_template_file => @testdata.multiplevalues_output_file
    )
    @templates.data_file = @testdata.multitemplate_specificfile_data_file
    @templates.expand
    
    @multiinstance_file_data = @testdata.read_file(@testdata.multipleinstance_template_file)
    @sample_file_data = @testdata.read_file(@testdata.sample_output_file)
  end
  
  it "should expand the specific template with the data specified for it" do
    @multiinstance_file_data.should include("first instance of 'the real value' is here.")
    @multiinstance_file_data.should include("b has a value of this is a second value")
  end  
  
  it "should use the global data when data for a specific template is not found in that templates specific data" do
    @multiinstance_file_data.should include("the value of a is a template file")
  end

  it "should not use the data from specified templates when the template name does not match" do
    @sample_file_data.should include("this is not the right one!!!")
  end
end

describe ExpandTemplates, "when including external data and specified placeholder is not found in local data" do
  it_should_behave_like "prepping the sample templates"
  
  before :all do
    @templates.expand_files @testdata.multipleinstance_template_file => @testdata.multipleinstance_template_file
    @templates.data_file = @testdata.sample_data_file_with_include
    @templates.expand
    
    @output_file_data = @testdata.read_file(@testdata.multipleinstance_template_file)
  end
  
  it "should use data from the included file" do
    @output_file_data.should include("first instance of 'the real value' is here.")
  end  
end

describe ExpandTemplates, "when including external data and specified placeholder is found in local data" do
  it_should_behave_like "prepping the sample templates"
  
  before :all do
    @templates.expand_files @testdata.multipleinstance_template_file => @testdata.multipleinstance_template_file
    @templates.data_file = @testdata.sample_data_file_with_include
    @templates.expand
    
    @output_file_data = @testdata.read_file(@testdata.multipleinstance_template_file)
  end
  
  it "should use data from the local file" do
    @output_file_data.should include("the value of a is data")
  end  
end

describe ExpandTemplates, "when when external data includes at least part of the data for a specific template" do
  it_should_behave_like "prepping the sample templates"
  
  before :all do
    @templates.expand_files @testdata.multipleinstance_template_file => @testdata.multipleinstance_template_file
    @templates.data_file = @testdata.template_specific_data_file_with_include
    @templates.expand
    
    @output_file_data = @testdata.read_file(@testdata.multipleinstance_template_file)
  end
  
  it "should use the external data that was supplied" do
    @output_file_data.should include("the value of a is data")
  end  
  
  it "should override the external data with template specific data from the local file" do
    @output_file_data.should include("first instance of 'the real value' is here.")
  end
end
