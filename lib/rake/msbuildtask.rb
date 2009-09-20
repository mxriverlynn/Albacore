require 'rake'
require 'rake/tasklib'

module MSBuild
	class MSBuildTask < Rake::TaskLib
		
		attr_accessor :name, :task_dependencies
		attr_accessor :msbuild_path, :solution_path
		
		def initialize(name=:MSBuild, task_dependencies={})
			@name = name
			@task_dependencies = task_dependencies
			yield self if block_given?
			define
		end
		
		def define
			task name => task_dependencies do
			end
		end
		
	end
end
