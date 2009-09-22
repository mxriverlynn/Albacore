require 'lib/albacore/msbuild'

module SystemPatch
	def system(cmd)
		$system_command = cmd
		super cmd
	end
end
