class FSharpEngine
  def build_attribute_re(attr_name)
    /^\[assembly: #{attr_name}(.+)/
  end

  def before
    "module AssemblyInfo" # this could be anything
  end

  def build_using_statement(namespace)
    "open #{namespace}"
  end

  def build_attribute(attr_name, attr_data)
    attribute = "[<assembly: #{attr_name}("
    attribute << "#{attr_data.inspect}" if attr_data != nil
    attribute << ")>]"

    attribute
  end

  def after
    "()" # need to yield unit
  end
end