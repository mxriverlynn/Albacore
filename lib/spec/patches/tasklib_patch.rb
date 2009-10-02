module TasklibPatch
	def fail
		$task_failed = true
	end
end