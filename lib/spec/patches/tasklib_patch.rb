module TasklibPatch
	$task_failed = false
	def fail
		$task_failed = true
	end
end