require 'albacore/assemblyinfolanguages/assemblyinfoengine'

class VbNetEngine < AssemblyInfoEngine
  def initialize
    @using       = "Imports"
    @start_token = "<"
    @end_token   = ">"
    @assignment  = ":="
  end
  
  def build_attribute_re(attr_name)
    /^\<assembly: #{attr_name}(.+)/  
  end
end