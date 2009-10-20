require 'rake/tasklib'

module Albacore
	class NCoverConsoleTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:ncoverconsole)
			@name = name
			@ncover = NCoverConsole.new
			yield @ncover if block_given?
			define
		end
		
		def define
			task name do
				@ncover.run
				fail if @ncover.failed
			end
		end	
	end
end
