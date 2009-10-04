require 'rake/tasklib'

module Rake
	class MSBuildTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:MSBuild)
			@name = name
			@msbuild = MSBuild.new
			yield @msbuild if block_given?
			define
		end
		
		def define
			task name do
				@msbuild.build
				fail if @msbuild.failed
			end
		end		
	end
end
