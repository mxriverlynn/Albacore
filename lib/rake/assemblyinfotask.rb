require 'rake/tasklib'

def create_task(taskname, &execute_body)
  taskclass = :"#{taskname}Task"
  taskmethod = taskname.to_s.downcase.to_sym
  # open up the metaclass for main
  (class << self; self; end).class_eval do
    # can't pass a default to a block parameter in ruby18
    define_method(taskmethod) do |*args, &block|
      # set default name if none given
      args << taskmethod if args.empty?
      Albacore.const_get(taskclass).new(*args, &block)
    end
  end
  Albacore.const_set(taskclass, Class.new(Albacore::AlbacoreTask) do
    define_method(:execute, &execute_body)
  end)
end


create_task :assemblyinfo do |name|
	puts ":::::::::::NAME: #{name}"
  asm = AssemblyInfo.new
  asm.load_config_by_task_name(name)
  call_task_block(asm)
  asm.write
  fail if asm.failed
end
