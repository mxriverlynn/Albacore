require 'rake/tasklib'

module Albacore
	class NUnitTestRunnerTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:nunit)
			@name = name
			@nunit = NUnitTestRunner.new
			yield @nunit if block_given?
			define
		end
		
		def define
			task name do
				@nunit.execute
				fail if @nunit.failed
			end
		end		
	end
end
