require 'rake/tasklib'

module Albacore
	class MSBuildTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:msbuild, &block)
			@name = name
			@msbuild = MSBuild.new
			@block = block
			define
		end
		
		def define
			task name do
				@block.call(@msbuild) unless @block.nil?
				@msbuild.build
				fail if @msbuild.failed
			end
		end		
	end
end
