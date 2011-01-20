require 'albacore/albacoretask'
require 'nokogiri'

class Nuget
  include Albacore::Task
  include Albacore::RunCommand
  
  attr_accessor :id, :version, :authors, :description, :language, :licenseUrl, :projectUrl, :output_file,
                :owners, :summary, :iconUrl, :requireLicenseAcceptance, :tags

  def initialize()
    super()
  end

  def execute
    valid = check_output_file @output_file
    check_required_field(@id, "id")
    check_required_field(@version, "version")
    check_required_field(@authors, "authors")
    check_required_field(@description, "description")
    
    if(! @working_directory.nil?)
      @working_output_file = File.join(@working_directory, @output_file)
    else
      @working_output_file = @output_file
    end

    return if !valid 

    builder = Nokogiri::XML::Builder.new do |xml|
      build(xml)
    end

    File.open(@working_output_file, 'w') {|f| f.write(builder.to_xml) }
    result = run_command "NuGet.exe", "pack #{@output_file}"
    
  end

  def build(xml)
         xml.package{
	   xml.metadata{
	     xml.id @id
             xml.version @version
             xml.authors @authors
             xml.description @description
             xml.language @language if !@language.nil?
             xml.licenseUrl @licenseUrl if !@licenseUrl.nil?
             xml.projectUrl @projectUrl if !@projectUrl.nil?
             xml.owners @owners if !@owners.nil?
             xml.summary @summary if !@summary.nil?
             xml.iconUrl @iconUrl if !@iconUrl.nil?
             xml.requireLicenseAcceptance @requireLicenseAcceptance if !@requireLicenseAcceptance.nil?
             xml.tags @tags if !@tags.nil?
           }
         }
  end

  def check_output_file(file)
    return true if file
    fail_with_message 'output_file cannot be nil'
    return false
  end

  def check_required_field(field, fieldname)
    return true if !field.nil?
    raise "Nuget: required field '#{fieldname}' is not defined"
  end
  
end