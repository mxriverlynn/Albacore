require 'rake/tasklib'

module Albacore
	class AssemblyInfoTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:assemblyinfo, &block)
			@name = name
			@block = block
			define
		end
		
		def define
			task name do
				@asm = AssemblyInfo.new
				@block.call(@asm) unless @block.nil?
				@asm.write
				fail if @asm.failed
			end
		end
	end
end
