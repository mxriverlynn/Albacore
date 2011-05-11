require 'nokogiri'

class XmlValidator
  def self.validate(xml_file, schema_file)
    schema = Nokogiri::XML::Schema(File.read(schema_file))
    doc = Nokogiri::XML::Document.parse(File.read(xml_file))

    validation = schema.validate(doc)
    validation.each do |error|
      raise error.message
    end

    return validation.length == 0
  end
end
