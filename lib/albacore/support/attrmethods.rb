module AttrMethods
  @@array_methods = {}
  @@hash_methods = {}
  
  def attr_array(*method_names)
  	@@array_methods[self] = method_names
  end
  
  def attr_hash(*method_names)
  	@@hash_methods[self] = method_names
  end
  
  def initialize
  	gen_array_methods(self, @@array_methods[self.class])
  	gen_hash_methods(self, @@hash_methods[self.class])
  	super()
  end

:private

  def gen_array_methods(obj, *method_names)
  	puts "------------#{method_names}"
  	puts "------------#{obj}"
    method_names.each do |m|
        obj.instance_eval(<<-EOF, __FILE__, __LINE__)
          def #{m}(*args)
            @#{m} = args
          end   
        EOF
    end
  end

  def gen_hash_methods(obj, *method_names)
    method_names.each do |m|
    	puts "------------ def #{m}"
        obj.instance_eval(<<-EOF, __FILE__, __LINE__)
          def #{m}(*args)
            @#{m} = *args
          end   
        EOF
    end
  end
end

Object.extend(AttrMethods)