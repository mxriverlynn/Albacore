module TasklibPatch
	attr_accessor :task_failed
	
	def initialize
		super()
		@task_failed = false
	end
	
	def fail
		@task_failed = true
	end
end