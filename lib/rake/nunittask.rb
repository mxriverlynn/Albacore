require 'rake/tasklib'

module Albacore
	class NUnitTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:nunit, &block)
			@name = name
			@nunit = NUnitTestRunner.new
			@block = block
			define
		end
		
		def define
			task name do
				@block.call(@nunit) unless @block.nil?
				@nunit.execute
				fail if @nunit.failed
			end
		end		
	end
end
