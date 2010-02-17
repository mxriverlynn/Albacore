require 'rake/tasklib'

def create_task(taskname, &execute_body)
  taskclass = :"Albacore_TaskFor_#{taskname}"
  taskmethod = taskname.to_s.downcase.to_sym

  Object.class_eval(<<-EOF, __FILE__, __LINE__)
    def #{taskmethod}(name, *args, &block)
      Albacore.const_get("#{taskclass}").new(name, *args, &block)
    end
  EOF

  Albacore.class_eval do
    const_set(taskclass, Class.new(Albacore::AlbacoreTask) do
      define_method(:execute, &execute_body)
    end)
  end
end

create_task :assemblyinfo do |name|
	puts ":::::::::::NAME: #{name}"
  asm = AssemblyInfo.new
  asm.load_config_by_task_name(name)
  call_task_block(asm)
  asm.write
  fail if asm.failed
end
