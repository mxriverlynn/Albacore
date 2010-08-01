def create_task(taskname, task_object)
  # this style of creating tasks is not really what i
  # want to do. but it's necessary for ruby 1.8.6
  # because that version doesn't support the foo do |*args, &block|
  # block signature. it supports *args, but not &block.
  # so that limitation is worked around with string eval
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
