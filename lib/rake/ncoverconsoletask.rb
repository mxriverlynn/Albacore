require 'rake/tasklib'

module Rake
	class NCoverConsoleTask < Rake::TaskLib
		attr_accessor :name
		
		def initialize(name=:NCover)
			@name = name
			@ncover = NCoverConsole.new
			yield @ncover if block_given?
			define
		end
		
		def define
			task name do
				@ncover.run
			end
		end	
	end
end