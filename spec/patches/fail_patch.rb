module FailPatch
  def self.extended(obj)
    $task_failed = false
  end
  
  def fail
    $task_failed = true
  end
end