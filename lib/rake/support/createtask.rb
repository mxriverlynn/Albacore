def create_task(taskname, task_object)
  Object.class_eval(<<-EOF, __FILE__, __LINE__)
    def #{taskname}(name=:#{taskname}, *args, &configblock)
      Rake::Task.define_task name, *args do |t, task_args|
        obj = #{task_object}.new
        obj.load_config_by_task_name(name)

        if !configblock.nil?
          case configblock.arity
            when 0
              configblock.call
            when 1
              configblock.call(obj)
            when 2
              configblock.call(obj, task_args)
          end
        end

        obj.execute if obj.respond_to?(:execute)
      end
    end
  EOF
end
