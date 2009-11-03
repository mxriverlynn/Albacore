require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/expandtemplates'
require 'expandtemplatestestdata'

shared_examples_for "prepping the sample templates" do
	before :all do
		@testdata = ExpandTemplatesTestData.new
		@testdata.prep_sample_templates
	end
end

describe ExpandTemplates, "when expanding a template file without specifying an output file" do
	it_should_behave_like "prepping the sample templates"
	
	before :each do
		templates = ExpandTemplates.new
		templates.expand_files << @testdata.sample_template_file
		templates.data_file = @testdata.sample_data_file
		templates.expand
	end
	
	it "should replace the @{value} placeholder with 'the real value'"
	
	it "should overwrite the original file"
end