require 'spec_helper.rb'
require 'albacore/nuspec.rb'
require 'support\nokogiri_validator'

describe Nuspec, 'when creating a file with minimum requirements' do
  let(:working_dir) { File.expand_path(File.join(File.dirname(__FILE__), 'support/nuspec/')) }
  let(:nuspec_output) { File.join(working_dir, 'nuspec_test.nuspec') }
  let(:schema_file) { File.join(working_dir, 'nuspec.xsd') }

  let(:nuspec) do
    nuspec = Nuspec.new
    nuspec.id="nuspec_test"
    nuspec.output_file = "nuspec_test.nuspec"
    nuspec.version = "1.2.3"
    nuspec.authors = "Author Name"
    nuspec.description = "test_xml_document"
    nuspec.working_directory = working_dir
    nuspec
  end

  before do
    nuspec.execute
  end

  it "should produce the nuspec xml" do
    File.exist?(nuspec_output).should be_true
  end

  it "should produce a valid xml file" do
    is_valid = XmlValidator.validate(nuspec_output, schema_file)
    is_valid.should be_true
  end
end
