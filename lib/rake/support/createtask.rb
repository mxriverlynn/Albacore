def create_task(taskname, &execute_body)
  taskclass = :"Albacore_TaskFor_#{taskname}"
  taskmethod = taskname.to_s.downcase.to_sym

  Object.class_eval(<<-EOF, __FILE__, __LINE__)
    def #{taskmethod}(name=:#{taskname}, *args, &block)
      Albacore.const_get("#{taskclass}").new(name, *args, &block)
    end
  EOF

  Albacore.class_eval do
    const_set(taskclass, Class.new(Albacore::AlbacoreTask) do
      define_method(:execute, &execute_body)
    end)
  end
end