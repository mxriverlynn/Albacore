require 'rake/tasklib'

module Albacore
	class XUnitTask < Rake::TaskLib
		attr_accessor :name

		def initialize(name=:xunit, &block)
			@name = name
			@block = block
			define
		end

		def define
			task name do
				@xunit = XUnitTestRunner.new
			  	@block.call(@xunit) unless @block.nil?
				@xunit.execute
				fail if @xunit.failed
			end
		end
	end
end