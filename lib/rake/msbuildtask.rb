require 'rake'
require 'rake/tasklib'

module Rake
	class MSBuildTask < Rake::TaskLib
		
		attr_accessor :name, :solution_path
		
		def initialize(name=:MSBuild, msbuild_path=nil)
			@name = name
			if msbuild_path==nil
				@msbuild = MSBuild.new
			else
				@msbuild = MSBiuld.new msbuild_path
			end
			yield @msbuild if block_given?
			define
		end
		
		def define
			task name do
				@msbuild.build @solution_path
			end
		end
		
	end
end
