require 'nokogiri'

class XmlValidator
  def self.validate(xml_file, schema_file)
    schema = Nokogiri::XML::Schema(File.open(schema_file))
    doc = Nokogiri::XML(File.open(xml_file))

    validation = schema.validate(doc)
    validation.each do |error|
      puts error.message
    end

    return validation.length == 0
  end
end
