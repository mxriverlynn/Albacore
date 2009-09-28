require 'rake/tasklib'

module Rake
	class MSBuildTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:MSBuild, msbuild_path=nil)
			@name = name
			@msbuild = MSBuild.new msbuild_path
			yield @msbuild if block_given?
			define
		end
		
		def define
			task name do
				@msbuild.build
			end
		end		
	end
end
