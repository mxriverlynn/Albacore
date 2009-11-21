require 'rake/tasklib'

module Albacore
	class MSpecTestRunnerTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:mspec, &block)
			@name = name
			@mspec = MSpecTestRunner.new
			@block = block
			define
		end
		
		def define
			task name do
		  	@block.call(@nunit) unless @block.nil?
				@mspec.execute
				fail if @mspec.failed
			end
		end		
	end
end