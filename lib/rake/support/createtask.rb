def create_task(taskname, task_object_proc, &execute_body)
  taskclass = :"Albacore_TaskFor_#{taskname}"
  taskmethod = taskname.to_s.downcase.to_sym

  Object.class_eval(<<-EOF, __FILE__, __LINE__)
    def #{taskmethod}(name=:#{taskname}, *args, &block)
      Albacore.const_get("#{taskclass}").new(name, *args, &block)
    end
  EOF

  Albacore.class_eval do
    const_set(taskclass, Class.new(Albacore::AlbacoreTask) do
      define_method :execute do |name|
        task_object = task_object_proc.call
        task_object.load_config_by_task_name(name)
        call_task_block(task_object)
      	execute_body.call(task_object) unless execute_body.nil?
      end
    end)
  end
end
