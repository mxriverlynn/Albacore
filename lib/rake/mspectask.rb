require 'rake/tasklib'

module Albacore
	class MSpecTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:mspec, &block)
			@name = name
			@block = block
			define
		end
		
		def define
			task name do
				@mspec = MSpecTestRunner.new
			  	@block.call(@mspec) unless @block.nil?
				@mspec.execute
				fail if @mspec.failed
			end
		end		
	end
end