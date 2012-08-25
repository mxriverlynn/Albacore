require 'albacore/assemblyinfolanguages/assemblyinfoengine'

class CppCliEngine < AssemblyInfoEngine
  def initialize
    @start_token = "["
    @end_token   = "]"
    @assignment  = "="
  end

  def build_attribute_re(attr_name)
    /^\[assembly: #{attr_name}(.+)/  
  end
  
  def build_using_statement(namespace)
    "using namespace #{namespace.gsub(/\./, '::')};"
  end
end