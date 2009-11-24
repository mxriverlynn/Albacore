require 'rake/tasklib'

module Albacore
	class XUnitTestRunnerTask < Rake::TaskLib
		attr_accessor :name

		def initialize(name=:xunit, &block)
			@name = name
			@xunit = XUnitTestRunner.new
			@block = block
			define
		end

		def define
			task name do
		  	@block.call(@xunit) unless @block.nil?
				@xunit.execute
				fail if @xunit.failed
			end
		end
	end
end