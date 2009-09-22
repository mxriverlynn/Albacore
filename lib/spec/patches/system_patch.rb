require 'lib/albacore/msbuild'

class MSBuild
	def system(cmd)
		$system_command = cmd
		super cmd
	end
end
