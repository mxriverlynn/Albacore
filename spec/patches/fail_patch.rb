module FailPatch
  def self.extended(obj)
    $task_failed = false
  end
  
  def fail(*args)
    $task_failed = true
  end
end