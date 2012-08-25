require 'albacore/assemblyinfolanguages/assemblyinfoengine'

class CSharpEngine < AssemblyInfoEngine
  def initialize
    @using       = "using"
    @start_token = "["
    @end_token   = "]"
    @assignment  = "="
  end
  
  def build_attribute_re(attr_name)
    /^\[assembly: #{attr_name}(.+)/  
  end
end