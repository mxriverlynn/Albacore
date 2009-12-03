require 'rake/tasklib'

module Albacore
	class MSBuildTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:msbuild, &block)
			@name = name
			@block = block
			define
		end
		
		def define
			task name do
				@msbuild = MSBuild.new
				@block.call(@msbuild) unless @block.nil?
				@msbuild.build
				fail if @msbuild.failed
			end
		end		
	end
end
