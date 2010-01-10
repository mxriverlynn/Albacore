module AttrMethods
  
  def attr_array(*names)
    names.each do |n|
      self.send :define_method, n do |*value|
        instance_variable_set "@#{n}", value
      end
      self.send :define_method, "#{n}=" do |value|
        instance_variable_set "@#{n}", value
      end
    end
  end
  
  def attr_hash(*names)
  	names.each do |n|
      self.send :define_method, n do |value|
        instance_variable_set "@#{n}", value
      end
      self.send :define_method, "#{n}=" do |value|
        instance_variable_set "@#{n}", value
      end
    end
  end

end
