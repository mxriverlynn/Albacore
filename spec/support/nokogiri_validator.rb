require 'nokogiri'

class XmlValidator
  def self.validate(xml_file, schema_file)
    schema = Nokogiri::XML::Schema(File.open(schema_file))
    doc = Nokogiri::XML(File.open(xml_file))
  
    validation = schema.validate(doc.xpath("//package").to_s)
    is_valid = (validation.length == 0)

    return is_valid
  end
end
