require 'albacore/assemblyinfolanguages/assemblyinfoengine'

class FSharpEngine < AssemblyInfoEngine
  def initialize
    @using       = "open"
    @start_token = "[<"
    @end_token   = ">]"
    @assignment  = "="
  end
  
  def build_attribute_re(attr_name)
    /^\[\<assembly: #{attr_name}(.+)/
  end
  
  def before
    "module AssemblyInfo" # this could be anything
  end
  
  def after
    "()" # need to yield unit
  end
end