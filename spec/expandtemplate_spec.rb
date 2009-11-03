require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/expandtemplates'
require 'expandtemplatestestdata'
require 'file_patch'

shared_examples_for "prepping the sample templates" do
	before :all do
		@testdata = ExpandTemplatesTestData.new
		@testdata.prep_sample_templates
		
		@templates = ExpandTemplates.new
		@templates.log_level = :verbose
	end
end

describe ExpandTemplates, "when expanding a template file without specifying an output file" do
	it_should_behave_like "prepping the sample templates"
	
	before :all do
		@templates.expand_files << @testdata.sample_template_file
		@templates.data_file = @testdata.sample_data_file
		@templates.expand
		
		@output_file_data = @testdata.read_file(@testdata.sample_template_file)
	end
	
	it "should replace the \#{value} placeholder with 'the real value'" do
		@output_file_data.should include("the real value")
	end
	
	it "should overwrite the original file" do
		$file_args[0].should == @testdata.sample_template_file
	end
end

describe ExpandTemplates, "when expanding a single value into multiple locations" do
	it_should_behave_like "prepping the sample templates"
	
	before :all do
		@templates.expand_files << @testdata.multipleinstance_template_file
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

describe ExpandTemplates, "when expanding a template file and specifying an output file" do
	it_should_behave_like "prepping the sample templates"
	
	before :all do
		@templates.expand_files << {@testdata.sample_template_file => @testdata.sample_output_file}
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
