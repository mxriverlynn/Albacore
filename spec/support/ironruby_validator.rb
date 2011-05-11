class XmlValidator
  require 'System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
  require 'System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'

  include System::Xml
  include System::Xml::Schema

  def self.validate(xml_file, xsd_file)
    xml = File.read(xml_file)

    settings = XmlReaderSettings.new
    settings.validation_type = ValidationType.Schema;
    settings.schemas.add(nil, xsd_file)

    is_valid = true
    settings.validation_event_handler { |s, e|
      is_valid = false if e.severity == XmlSeverityType.error
    }

    reader = XmlReader.create(System::IO::StringReader.new(xml), settings)
    while reader.read
    end

    return is_valid
  end
end
