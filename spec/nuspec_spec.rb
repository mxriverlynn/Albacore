require 'rubygems'
require '../lib/albacore/nuspec.rb'
require 'spec/rake/spectask'
require 'nokogiri'

#require 'spec_helper.rb'

describe Nuspec, 'when creating a file with minimum requirements' do
  before :each do
    @nuspec = Nuspec.new
    @nuspec.id="nuspec_test"
    @nuspec.output_file = "nuspec_test.nuspec"
    @nuspec.version = "1.2.3"
    @nuspec.authors = "Author Name"
    @nuspec.description = "test_xml_document"
    @nuspec.working_directory = 'support/nuspec'
    @nuspec.execute
  end

  it "should produce a valid xml file" do
    File.exist?("support/nuspec/nuspec_test.nuspec").should be_true
    schema = Nokogiri::XML::Schema(File.open('support/nuspec/nuspec.xsd'))
    doc = Nokogiri::XML(File.open('support/nuspec/nuspec_test.nuspec'))
  
    schema.validate(doc.xpath("//package").to_s).each do |error|
      puts error.message
    end
    schema.validate(doc).length.should == 0
  end
end

