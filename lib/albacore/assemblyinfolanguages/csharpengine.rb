class CSharpEngine
  def build_attribute_re(attr_name)
    /^\[assembly: #{attr_name}(.+)/  
  end

  def build_attribute(attr_name, attr_data)
    attribute = "[assembly: #{attr_name}("
    
    if attr_data != nil
      if attr_data.is_a? Hash
        # Only named parameters
        attribute << build_named_parameters(attr_data)
      elsif attr_data.is_a? Array
        if attr_data.last.is_a? Hash
          # Positional and named parameters
          attribute << build_positional_parameters(attr_data.slice(0, attr_data.length - 1))
          attribute << ", "
          attribute << build_named_parameters(attr_data.last)
        else
          # Only positional parameters
          attribute << build_positional_parameters(attr_data)
        end
      else
        # Single positional parameter
        attribute << "#{attr_data.inspect}"
      end
    end
    
    attribute << ")]"
  end
  
  def build_named_parameters(data)
    params = []
    data.each_pair { |k, v| params << "#{k.to_s} = #{v.inspect}" }
    params.join(", ")
  end
  
  def build_positional_parameters(data)
    data.flatten.map{ |a| a.inspect }.join(", ")
  end

  def build_using_statement(namespace)
    "using #{namespace};"
  end
    
end
